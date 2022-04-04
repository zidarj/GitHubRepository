//
//  GHPagination.swift
//  GitHubRepository
//
//  Created by Josip Zidar on 04.04.2022..
//

import Foundation
import SwiftyJSON

struct GHPagination {
    
    /// Total number of items that can be received through pagination
    var total: Int
    /// Limit per page
    let limit: Int
    let lastPage: Int
    var currentPage: Int
    
    /// Init for Paging
    init(jsonData: JSON) {
        total = jsonData["total_count"].intValue
        lastPage = jsonData["lastPage"].intValue
        limit = jsonData["perPage"].intValue
        currentPage = jsonData["page"].intValue
    }
    
    init(limit: Int? = nil) {
        total = 0
        self.limit = limit ?? 10
        lastPage = 10
        currentPage = 1
    }
    
    func asParams() -> [String: Any] {
        return ["page": currentPage, "per_page": limit]
    }
}



extension GHPagination {
    var nextPage: Int {
        return currentPage + 1
    }
    
    var isLastPage: Bool {
        return lastPage <= currentPage && total <= (limit * currentPage)
    }
}
