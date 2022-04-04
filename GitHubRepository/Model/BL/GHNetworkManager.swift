//
//  GHNetworkManager.swift
//  GitHubRepository
//
//  Created by Josip Zidar on 04.04.2022..
//

import Foundation

extension GHEndpoint {
    static let searchRepositories = apiURL + "search/repositories"
    static let userInfo = apiURL + "users/"
}
struct GHNetworkManager {
    private init() {}
    
    static func searchRepositories(params: GHSearchParams,
                                   success: @escaping (([GHRepository], GHPagination) -> Void),
                                   failure: @escaping (Error) -> Void) -> GHDataRequest {
        return GHNetworkLayer.request(toURL: GHEndpoint.searchRepositories, withMethod: .get, withParams: params.params()) { (json, _)  in
            OnMainThread {
                let repositories = json["items"].arrayValue.map({GHRepository(with: $0)})
                let pagination = GHPagination(jsonData: json)
                success(repositories, pagination)
            }
        } failure: { error in
            OnMainThread {
                failure(error)
            }
        }
    }
    
    static func getUserInfo(username: String,
                            success: @escaping ((GHOwner) -> Void),
                            failure: @escaping (Error) -> Void) -> GHDataRequest {
        return GHNetworkLayer.request(toURL: GHEndpoint.userInfo + username, withMethod: .get, withParams: nil) { (json, _)  in
            OnMainThread {
                success(GHOwner(with: json))
            }
        } failure: { error in
            OnMainThread {
                failure(error)
            }
        }
    }
}
