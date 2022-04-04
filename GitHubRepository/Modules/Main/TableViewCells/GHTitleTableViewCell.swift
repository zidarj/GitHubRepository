//
//  GHTitleTableViewCell.swift
//  GitHubRepository
//
//  Created by Josip Zidar on 04.04.2022..
//

import UIKit

final class GHTitleTableViewCell: UITableViewCell {
    struct Configuration {
        var title: String
        var font: UIFont = .boldSystemFont(ofSize: 20)
        var alignment: NSTextAlignment = .right
        var numberOfLines: Int = 0
        var icon: UIImage? = nil
    }
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var imageWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    final func config(with config: Configuration) {
        titleLabel.font = config.font
        titleLabel.text = config.title
        titleLabel.textAlignment = config.alignment
        titleLabel.numberOfLines = config.numberOfLines
        if let img = config.icon {
            iconImageView.isHidden = false
            imageWidthConstraint.constant = 25
            iconImageView.image = img.withRenderingMode(.alwaysTemplate)
            
        }
    }
    
}
