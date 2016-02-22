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
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var retweetImageView2: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // add gesture recognizer
        let retweetTapGestureRecognizer = UITapGestureRecognizer()
        retweetTapGestureRecognizer.addTarget(self, action: "retweetTapped:")
        retweetImageView2.addGestureRecognizer(retweetTapGestureRecognizer)
        retweetImageView2.userInteractionEnabled = true
        let shareTapGestureRecognizer = UITapGestureRecognizer()
        shareTapGestureRecognizer.addTarget(self, action: "shareTapped:")
        shareImageView.addGestureRecognizer(shareTapGestureRecognizer)
        shareImageView.userInteractionEnabled = true

        let likeTapGestureRecognizer = UITapGestureRecognizer()
        likeTapGestureRecognizer.addTarget(self, action: "likeTapped:")
        likeImageView.addGestureRecognizer(likeTapGestureRecognizer)
        likeImageView.userInteractionEnabled = true

        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true


    }
    
    func retweetTapped(image: AnyObject) {
        print("retweet")
    }
    
    func shareTapped(image: AnyObject) {
        print("share")

    }
    
    func likeTapped(image: AnyObject) {
        print("like")

    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
