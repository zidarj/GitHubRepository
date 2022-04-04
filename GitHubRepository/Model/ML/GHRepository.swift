//
//  GHRepository.swift
//  GitHubRepository
//
//  Created by Josip Zidar on 04.04.2022..
//

import Foundation
import SwiftyJSON

struct GHRepository {
    var name: String
    var owner: GHOwner
    var createDate: String
    var lastUpdate: String
    var pushedAt: String
    var description: String
    init(with json: JSON) {
        self.name = json["name"].stringValue
        self.owner = GHOwner(with: json["owner"])
        self.createDate = json["created_at"].stringValue
        self.lastUpdate = json["updated_at"].stringValue
        self.pushedAt = json["pushed_at"].stringValue
        self.description = json["description"].stringValue
    }
}
