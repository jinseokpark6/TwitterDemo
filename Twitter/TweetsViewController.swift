//
//  TweetsViewController.swift
//  Twitter
//
//  Created by WUSTL STS on 2/21/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    


    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        // used for scroll height
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()


        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            
            self.tweets = tweets
            
            self.tableView.reloadData()
            
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        
        TwitterClient.sharedInstance.logout()
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! TweetDetailViewController
        vc.tweet = sender as! Tweet
        
        
    }


}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
//        cell.selectionStyle = UITableViewCellSelectionStyle.None

        
        if self.tweets != nil {
            let tweet = self.tweets[indexPath.row]
            cell.tweet = tweet
            cell.userNameLabel.text = tweet.name
            print("username")
            print(cell.userNameLabel.text)
            cell.userIdLabel.text = tweet.screenName
            if let profileURL = tweet.user?.profileURL {
                cell.userImageView.setImageWithURL(profileURL)
            }

            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd"
            cell.timeLabel.text = formatter.stringFromDate(tweet.timeStamp!)
            cell.tweetLabel.text = tweet.text
            cell.retweetCountLabel.text = "\(tweet.retweetCount)"
            cell.likeCountLabel.text = "\(tweet.favoritesCount)"
            if tweet.favorited == 1 {
                cell.likeImageView.tintColor = UIColor(red: 1.0, green: 199/255.0, blue: 38/255.0, alpha: 1.0)
            } else {
                cell.likeImageView.tintColor = UIColor.lightGrayColor()
            }
            if tweet.retweeted == 1 {
                cell.retweetImageView2.tintColor = UIColor(red: 1.0, green: 199/255.0, blue: 38/255.0, alpha: 1.0)
            } else {
                cell.retweetImageView2.tintColor = UIColor.lightGrayColor()
            }
        }
        
        // add gesture recognizer
        let retweetTapGestureRecognizer = UITapGestureRecognizer()
        retweetTapGestureRecognizer.addTarget(self, action: "retweetTapped:")
        cell.retweetImageView2.addGestureRecognizer(retweetTapGestureRecognizer)
        cell.retweetImageView2.userInteractionEnabled = true
        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TweetCell
        self.performSegueWithIdentifier("goToTweetDetail", sender: cell.tweet)
    }
    
    func retweetTapped(sender: AnyObject) {
        let point: CGPoint = sender.locationInView(self.tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        let cell = tableView.cellForRowAtIndexPath(indexPath!) as! TweetCell
        let count = Int(cell.retweetCountLabel.text!)
        if cell.retweetImageView2.tintColor == UIColor.lightGrayColor() {
            cell.retweetCountLabel.text = "\(count!+1)"
            let params = ["id": cell.tweet.id!] as NSDictionary
            TwitterClient.sharedInstance.retweetWithId(cell.tweet, params: params) { () -> () in
                print("successfully retweeted!")
            }
            cell.retweetImageView2.tintColor = UIColor(red: 1.0, green: 199/255.0, blue: 38/255.0, alpha: 1.0)
        } else {
            cell.retweetCountLabel.text = "\(count!-1)"
            let params = ["id": cell.tweet.id!] as NSDictionary
            TwitterClient.sharedInstance.unretweetWithId(cell.tweet, params: params, completion: { () -> () in
                print("successfully unretweeted!")
            })
            cell.retweetImageView2.tintColor = UIColor.lightGrayColor()
        }
    }
    
    func shareTapped(sender: AnyObject) {
        print("share")
        
    }
    
    func likeTapped(sender: AnyObject) {
        let point: CGPoint = sender.locationInView(self.tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        let cell = tableView.cellForRowAtIndexPath(indexPath!) as! TweetCell
        let count = Int(cell.likeCountLabel.text!)
        if cell.likeImageView.tintColor == UIColor.lightGrayColor() {
            cell.likeCountLabel.text = "\(count!+1)"
            let params = ["id": cell.tweet.id!] as NSDictionary
            TwitterClient.sharedInstance.favoriteTweet(cell.tweet, params: params) { () -> () in
                print("successfully liked!")
            }
            cell.likeImageView.tintColor = UIColor(red: 1.0, green: 199/255.0, blue: 38/255.0, alpha: 1.0)
        } else {
            cell.likeCountLabel.text = "\(count!-1)"
            let params = ["id": cell.tweet.id!] as NSDictionary
            TwitterClient.sharedInstance.unfavoriteTweet(cell.tweet, params: params, completion: { () -> () in
                print("successfully unliked!")
            })
            cell.likeImageView.tintColor = UIColor.lightGrayColor()
        }

    }

}
