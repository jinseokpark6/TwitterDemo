//
//  TweetDetailIconCell.swift
//  Twitter
//
//  Created by WUSTL STS on 2/28/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

class TweetDetailIconCell: UITableViewCell {

    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        shareImageView.image = UIImage(named: "Share.png")
        let likeImage = UIImage(named: "LikeIcon.png");
        let likeTintedImage = likeImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        likeImageView.image = likeTintedImage
        let retweetImage = UIImage(named: "RetweetIcon.png");
        let retweetTintedImage = retweetImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        retweetImageView.image = retweetTintedImage

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
