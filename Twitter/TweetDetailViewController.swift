//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by WUSTL STS on 2/28/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

protocol TweetDetailViewControllerDelegate {
    func TweetDetailViewControllerDidSelect(value: String)
}

class TweetDetailViewController: UIViewController {

    var delegate : TweetDetailViewControllerDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    var tweet: Tweet!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        // used for scroll height
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TweetDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TweetDetailCell", forIndexPath: indexPath) as! TweetDetailCell
            
            cell.idLabel.text = tweet.user!.id
            cell.nameLabel.text = tweet.user!.name
            cell.tweetLabel.text = tweet.text
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM d, y, h:mm a"
            cell.dateLabel.text = formatter.stringFromDate(tweet.timeStamp!)
            if let profileURL = tweet.user?.profileURL {
                cell.userImageView.setImageWithURL(profileURL)
            }
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TweetDetailLabelCell", forIndexPath: indexPath) as! TweetDetailLabelCell
            
            cell.retweetLabel.text = "\(tweet.retweetCount)"
            cell.favoriteLabel.text = "\(tweet.favoritesCount)"
            
            
            
            return cell

        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("TweetDetailIconCell", forIndexPath: indexPath) as! TweetDetailIconCell
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}
