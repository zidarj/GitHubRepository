//
//  GHMainViewModel.swift
//  GitHubRepository
//
//  Created by Josip Zidar on 04.04.2022..
//

import Foundation

final class GHMainViewModel {
    private var request: GHDataRequest?
    private weak var delegate: GHNetworkRequestableDelegate?
    private(set) var repositories: [GHRepository] = []
    var params: GHSearchParams = GHSearchParams()
    init(delegate: GHNetworkRequestableDelegate?) {
        self.delegate = delegate
    }
    
    final func resetSearch() {
        repositories.removeAll()
        self.delegate?.didFetch()
    }
    
    final func searchRepositories(requestType: GHRequestType = .initial) {
        guard request?.isActive != true else { return }
        switch requestType {
        case .initial, .refresh:
            repositories.removeAll()
            params.pagination.currentPage = 1
            
        case .pagination:
            guard repositories.count < params.pagination.total else { return }
            params.pagination.currentPage += 1
            
        }
        
        request = GHNetworkManager.searchRepositories(params: params, success: { [weak self] repositories, pagination in
            guard let welf = self else { return }
            welf.request?.cancel()
            OnMainThread {
                welf.repositories.append(contentsOf: repositories)
                welf.params.pagination.total = pagination.total
                welf.delegate?.didFetch()
            }
        }, failure: { [weak self] error in
            guard let welf = self else { return }
            welf.request?.cancel()
            OnMainThread {
                welf.delegate?.didReceiveError(error)
            }
        })
        self.delegate?.didPerformRequest(request)
    }
}



