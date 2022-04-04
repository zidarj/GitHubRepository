//
//  GHRepositoryTableViewCell.swift
//  GitHubRepository
//
//  Created by Josip Zidar on 04.04.2022..
//

import UIKit

final class GHRepositoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var repositoryName: UILabel!
    @IBOutlet private weak var lastUpdateLabel: UILabel!
    private var repository: GHRepository!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    final func config(repository: GHRepository) {
        self.repository = repository
        repositoryName.text = repository.name
        lastUpdateLabel.text = "Updated on " + repository.pushedAt.stringToDate.dateToString
    }
    
   
}
