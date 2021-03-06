//
//  TweetCell.swift
//  Twitter
//
//  Created by WUSTL STS on 2/21/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var randomImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var retweetImageView2: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    var tweet: Tweet!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true

        shareImageView.image = UIImage(named: "Share.png")
        let likeImage = UIImage(named: "LikeIcon.png");
        let likeTintedImage = likeImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        likeImageView.image = likeTintedImage
        let retweetImage = UIImage(named: "RetweetIcon.png");
        let retweetTintedImage = retweetImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        retweetImageView2.image = retweetTintedImage

    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
