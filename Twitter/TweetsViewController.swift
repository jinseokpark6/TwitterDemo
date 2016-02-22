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
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            
            self.tweets = tweets
            
            for tweet in tweets {
                print(tweet.text)
            }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.textLabel?.numberOfLines = 0
        print("text")
        print(self.tweets[indexPath.row].text)
        if self.tweets != nil {
            let tweet = self.tweets[indexPath.row]
            cell.userNameLabel.text = tweet.name
            cell.userIdLabel.text = tweet.screenName
            if let profileURL = tweet.profileUrl {
                cell.imageView?.setImageWithURL(NSURL(string: profileURL)!)
            }
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd"
            cell.timeLabel.text = formatter.stringFromDate(tweet.timeStamp!)
            cell.tweetLabel.text = tweet.text
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            print(self.tweets.count)
            return self.tweets.count
        } else {
            return 0
        }
    }
}
