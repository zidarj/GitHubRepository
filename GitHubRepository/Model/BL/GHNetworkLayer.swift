//
//  GHNetworkLayer.swift
//  GitHubRepository
//
//  Created by Josip Zidar on 04.04.2022..
//

import UIKit
import Alamofire
import SwiftyJSON
class GHDataRequest {
    
    private var request: DataRequest?
    
    init(req: DataRequest?) {
        request = req
    }
    
    var isActive: Bool {
        return request != nil
    }
    
    final func cancel() {
        request?.cancelRequest()
        request = nil
    }
}

extension DataRequest {
    func cancelRequest() {
        self.cancel()
    }
}

enum GHRequestType {
    /// Initial fetch in pagination
    case initial
    /// Every pagination fetch, other then initial
    case pagination
    
    case refresh
}

protocol GHNetworkRequestableDelegate: AnyObject {
    func didPerformRequest(_ req: GHDataRequest?)
    func didReceiveError(_ error: Error)
    func didFetch()
    
}

class GHNetworkLayer: NSObject {
    
    // MARK: Singleton
    static let shared = GHNetworkLayer()
    private override init() {}
    
    private lazy var manager: Alamofire.Session = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        
        return Alamofire.Session(configuration: config)
    }()
    
    // MARK: - Headers
    private func getHeaders(for passedHeaders: [String: String]?) -> HTTPHeaders {
        var headers: [String: String] = passedHeaders ?? [:]
        headers["accept"] = "application/vnd.github.v3+json"
        return HTTPHeaders(headers)
    }
    
    @discardableResult
    public static func request(toURL url: String,
                               withMethod method: HTTPMethod,
                               withParams params: [String: Any]?,
                               andHeaders headers: [String: String]? = nil,
                               success: @escaping ((JSON, Int) -> Void),
                               failure: @escaping (Error) -> Void) -> GHDataRequest {
        
        var finalHeaders: HTTPHeaders? {
            return HTTPHeaders(headers ?? [:])
        }
        
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default: JSONEncoding.default
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? url
        
        let dataRequest = shared.manager.request(encodedURL, method: method, parameters: params, encoding: encoding, headers: finalHeaders)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
            
                OnBackgroundThreadWith(.user_initiated, {
                    
                    let json = JSON(response.value ?? [])
                    switch response.result {
                    case .success(_):
                        
                        let statusCode = response.response?.statusCode ?? -1
                        if statusCode >= 200 && statusCode < 400 {
                            success(json, response.response?.statusCode ?? 1)
                        } else {
                            let error = NSError(domain: json["code"].stringValue, code: -1, userInfo: [NSLocalizedDescriptionKey: json["message"].stringValue])
                            OnMainThread {
                                failure(error)
                            }
                        }
                        debugPrint(json)
                        
                    case .failure(let error):
                        if let error = error as NSError?, error.code == NSURLErrorCancelled {
                            print("Request has been cancelled")
                        } else if let error = error as AFError?, error.isExplicitlyCancelledError {
                            print("Request has been explicitly cancelled")
                        } else {
                            OnMainThread {
                                failure(error)
                            }
                        }
                    }
                })
        }
        
        dataRequest.cURLDescription { (curl) in
            print(curl)
        }
        
        return GHDataRequest(req: dataRequest)
    }
}
