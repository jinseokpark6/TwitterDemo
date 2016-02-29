//
//  TweetDetailCell.swift
//  Twitter
//
//  Created by WUSTL STS on 2/28/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

class TweetDetailCell: UITableViewCell {

    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var tweet: Tweet!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true
        
        retweetImageView.image = UIImage(named: "RetweetIcon.png")

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
