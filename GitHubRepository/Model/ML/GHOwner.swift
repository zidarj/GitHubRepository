//
//  GHOwner.swift
//  GitHubRepository
//
//  Created by Josip Zidar on 04.04.2022..
//

import Foundation
import SwiftyJSON

struct GHOwner {
    var username: String
    var id: Int
    var name: String?
    init(with json: JSON) {
        self.username = json["login"].stringValue
        self.id = json["id"].intValue
        self.name = json["name"].string
       
    }
}

