//
//  Copyright © 2018 Frallware. All rights reserved.
//

import UIKit
import Services
import Frallware
import SDWebImage

class FeedEntryCell: UITableViewCell, NibBased {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!

    private var imageRatioConstraint: NSLayoutConstraint?

    func configure(entry: FeedEntry) -> FeedEntryCell {

        let ratio = entry.image.size.height / entry.image.size.width
        imageRatioConstraint?.isActive = false
        imageRatioConstraint = feedImageView.heightAnchor.constraint(equalTo: feedImageView.widthAnchor,
                                                                     multiplier: ratio)
        imageRatioConstraint?.isActive = true

        titleLabel.text = entry.title
        feedImageView.sd_setImage(with: entry.image.url)
        
        return self
    }
}
