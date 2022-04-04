//
//  GHEndpoint.swift
//  GitHubRepository
//
//  Created by Josip Zidar on 04.04.2022..
//

import UIKit

fileprivate(set) public var apiURL: String = "https://api.github.com/"

public struct GHEndpoint {
    public static func setApiURL(_ url: String) {
        apiURL = url
    }
}
