//
//  TweetDetailLabelCell.swift
//  Twitter
//
//  Created by WUSTL STS on 2/28/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

class TweetDetailLabelCell: UITableViewCell {

    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
