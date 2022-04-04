//
//  GHSearchParams.swift
//  GitHubRepository
//
//  Created by Josip Zidar on 04.04.2022..
//

import Foundation

struct GHSearchParams {
    var searchText: String?
    var pagination: GHPagination
    
    init() {
        searchText = nil
        pagination = GHPagination()
    }
    
    func params() -> [String: Any] {
        var params: [String: Any] = pagination.asParams()
        if let searchText = searchText {
            params["q"] = searchText
        }
        
        params["sort"] = "updated"
    
        return params
    }
}
