//
//  GHRepositoryDetailsViewModel.swift
//  GitHubRepository
//
//  Created by Josip Zidar on 04.04.2022..
//

import Foundation

final class GHRepositoryDetailsViewModel {
    
    enum Cells {
        case repositoryName
        case lastUpdateTime
        case ownerName
        case description
    }
    
    private(set) var repository: GHRepository!
    private(set) var owner: GHOwner?
    var structure: [Cells] {
        var str: [Cells] = [.repositoryName, .lastUpdateTime]
        if let owner = owner, owner.name != nil {
            str.append(.ownerName)
        }
        if !repository.description.isEmpty {
            str.append(.description)
        }
        return str
    }
    private var request: GHDataRequest?
    private weak var delegate: GHNetworkRequestableDelegate?
    
    init(with repository: GHRepository, delegate: GHNetworkRequestableDelegate?) {
        self.repository = repository
        self.delegate = delegate
        self.getUserInfo(username: repository.owner.username)
        
    }
    
    private func getUserInfo(username: String) {
        guard !username.isEmpty else { return }
        request?.cancel()
        request = GHNetworkManager.getUserInfo(username: username, success: { [weak self] user in
            guard let welf = self else { return }
            OnMainThread {
                welf.owner = user
                welf.delegate?.didFetch()
            }
        }, failure: { [weak self] error in
            guard let welf = self else { return }
            OnMainThread {
                welf.delegate?.didReceiveError(error)
            }
        })
        self.delegate?.didPerformRequest(request)
    }
}
