//
//  GHMainControllerHelper.swift
//  GitHubRepository
//
//  Created by Josip Zidar on 04.04.2022..
//

import Foundation
import UIKit

extension UIStoryboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
}

final class GHMainControllerHelper {
    private init() {}
    
    static func openRepositoryDetails(from vc: UIViewController, repository: GHRepository) {
        let view: GHRepositoryDetailsViewController = UIStoryboard.main.getController()
        view.config(repository: repository)
        vc.navigationController?.pushViewController(view, animated: true)
    }
}

