//
//  TwitterClient.swift
//  Twitter
//
//  Created by WUSTL STS on 2/15/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

//import Cocoa
import BDBOAuth1Manager

let twitterBaseUrl = NSURL(string: "https://api.twitter.com")
let twitterConsumerKey = "RiP9VTxnwhbR99KENiQFziZ8O"
let twitterConsumerSecret = "FPOMi1TF4lW35dBDirn8mE1pxNqqRgffAGrk5O30UYbju6a0Pi"


class TwitterClient: BDBOAuth1RequestOperationManager {
    
    
    static let sharedInstance = TwitterClient(
        baseURL: twitterBaseUrl,
        consumerKey: twitterConsumerKey,
        consumerSecret: twitterConsumerSecret)

//    class var sharedInstance: TwitterClient {
//        struct Static {
//        }
//        
//        return Static.instance
//    }
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
    func favoriteTweet(id: String?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.POST("1.1/favorites/create.json?id=\(id!)", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("failed at favoriting")
                completion(tweet: nil, error: error)
        })
    }
    
    func retweetTweet(id: String?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.POST("1.1/statuses/retweet/\(id!).json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("failed at favoriting")
                completion(tweet: nil, error: error)
        })
    }

    func openURL(url: NSURL) {
        
        let client = TwitterClient.sharedInstance

        client.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            print("Got the access token!")
            client.requestSerializer.saveAccessToken(accessToken)
            client.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error)
            })
            client.homeTimeline({ (tweets: [Tweet]) -> () in
                for tweet in tweets {
                    print(tweet.text)
                }
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
            
            self.loginSuccess?()
            
            
        }) { (error: NSError!) -> Void in
            print("Failed to receive access token")
            
            self.loginFailure?(error)
        }

    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            print("user: \(response)")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
            failure(error)
        })
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {

        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            
        }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
            failure(error)
        })

    }
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cputwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print ("got the request token.")
            
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            
        }) { (error: NSError!) -> Void in
            print ("failed to get request token.")
            self.loginFailure?(error)
            
                
        }

    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
        
    }


}
