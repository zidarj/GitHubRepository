//
//  GHDescriptionTableViewCell.swift
//  GitHubRepository
//
//  Created by Josip Zidar on 04.04.2022..
//

import UIKit

final class GHDescriptionTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    final func config(with title: String, description: String) {
        titleLabel.text = title
        titleLabel.isHidden = title.isEmpty
        descriptionLabel.text = description
    }
    
}
