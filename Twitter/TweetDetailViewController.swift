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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let navigationController = segue.destinationViewController as! UINavigationController
        let vc = navigationController.topViewController as! TweetComposeViewController
        vc.user = tweet.user
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
            
            cell.idLabel.text = "@\(tweet.user!.screenName!)"
            cell.nameLabel.text = tweet.user!.name
            cell.tweetLabel.text = tweet.text
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM d y, h:mm a"
            cell.dateLabel.text = formatter.stringFromDate(tweet.timeStamp!)
            if let profileURL = tweet.user?.profileURL {
                cell.userImageView.setImageWithURL(profileURL)
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None

            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TweetDetailLabelCell", forIndexPath: indexPath) as! TweetDetailLabelCell
            
            cell.retweetLabel.text = "\(tweet.retweetCount)"
            cell.favoriteLabel.text = "\(tweet.favoritesCount)"
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None

            
            return cell

        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("TweetDetailIconCell", forIndexPath: indexPath) as! TweetDetailIconCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None

            
            if tweet.favorited == 1 {
                cell.likeImageView.tintColor = UIColor(red: 1.0, green: 199/255.0, blue: 38/255.0, alpha: 1.0)
            } else {
                cell.likeImageView.tintColor = UIColor.lightGrayColor()
            }
            if tweet.retweeted == 1 {
                cell.retweetImageView.tintColor = UIColor(red: 1.0, green: 199/255.0, blue: 38/255.0, alpha: 1.0)
            } else {
                cell.retweetImageView.tintColor = UIColor.lightGrayColor()
            }

            // add gesture recognizer
            let retweetTapGestureRecognizer = UITapGestureRecognizer()
            retweetTapGestureRecognizer.addTarget(self, action: "retweetTapped:")
            cell.retweetImageView.addGestureRecognizer(retweetTapGestureRecognizer)
            cell.retweetImageView.userInteractionEnabled = true
            
            let shareTapGestureRecognizer = UITapGestureRecognizer()
            shareTapGestureRecognizer.addTarget(self, action: "shareTapped:")
            cell.shareImageView.addGestureRecognizer(shareTapGestureRecognizer)
            cell.shareImageView.userInteractionEnabled = true
            
            let likeTapGestureRecognizer = UITapGestureRecognizer()
            likeTapGestureRecognizer.addTarget(self, action: "likeTapped:")
            cell.likeImageView.addGestureRecognizer(likeTapGestureRecognizer)
            cell.likeImageView.userInteractionEnabled = true

            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
}

extension TweetDetailViewController {
    
    func retweetTapped(sender: AnyObject) {
        if tweet.user!.id != User.currentUser!.id {
            let labelCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! TweetDetailLabelCell
            let iconCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! TweetDetailIconCell
            let count = Int(labelCell.retweetLabel.text!)
            if iconCell.retweetImageView.tintColor == UIColor.lightGrayColor() {
                labelCell.retweetLabel.text = "\(count!+1)"
                let params = ["id": tweet.id!] as NSDictionary
                TwitterClient.sharedInstance.retweetWithId(tweet, params: params) { () -> () in
                    print("successfully retweeted!")
                }
                iconCell.retweetImageView.tintColor = UIColor(red: 1.0, green: 199/255.0, blue: 38/255.0, alpha: 1.0)
            } else {
                labelCell.retweetLabel.text = "\(count!-1)"
                let params = ["id": tweet.id!] as NSDictionary
                TwitterClient.sharedInstance.unretweetWithId(tweet, params: params, completion: { () -> () in
                    print("successfully unretweeted!")
                })
                iconCell.retweetImageView.tintColor = UIColor.lightGrayColor()
            }
        }
    }
    
    func shareTapped(sender: AnyObject) {
        print("share")
        
    }
    
    func likeTapped(sender: AnyObject) {
        let labelCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! TweetDetailLabelCell
        let iconCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! TweetDetailIconCell
        let count = Int(labelCell.favoriteLabel.text!)
        if iconCell.likeImageView.tintColor == UIColor.lightGrayColor() {
            labelCell.favoriteLabel.text = "\(count!+1)"
            let params = ["id": tweet.id!] as NSDictionary
            TwitterClient.sharedInstance.favoriteTweet(tweet, params: params) { () -> () in
                print("successfully liked!")
            }
            iconCell.likeImageView.tintColor = UIColor(red: 1.0, green: 199/255.0, blue: 38/255.0, alpha: 1.0)
        } else {
            labelCell.favoriteLabel.text = "\(count!-1)"
            let params = ["id": tweet.id!] as NSDictionary
            TwitterClient.sharedInstance.unfavoriteTweet(tweet, params: params, completion: { () -> () in
                print("successfully unliked!")
            })
            iconCell.likeImageView.tintColor = UIColor.lightGrayColor()
        }
        
    }

}
