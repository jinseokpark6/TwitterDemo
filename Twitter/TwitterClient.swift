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
    
    
    func favoriteTweet(tweet: Tweet, params: NSDictionary?, completion: () ->()) {
        POST("1.1/favorites/create.json", parameters:params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject?) -> Void in
            print("Favorited tweet: \(tweet.id)")
            tweet.favorited = 1
            let dict = response as! NSDictionary
            tweet.favoritesCount += 1
            completion()
            
            }, failure: { (operation: AFHTTPRequestOperation?, error:NSError) -> Void in
                print("Failed to favorite: \(error)")
        })
    }
    func retweetWithId(tweet: Tweet, params: NSDictionary?, completion: () ->()) {
        POST("1.1/statuses/retweet/\(tweet.id!).json", parameters:params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject?) -> Void in
            print("Retweeted tweet: \(tweet.id)")
            tweet.retweeted = 1
            let dict = response as! NSDictionary
            tweet.retweetCount = dict["retweet_count"] as! Int
            completion()
            
            
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("Failed to retweet: \(error)")
        })
    }
    
    
    func unretweetWithId(tweet: Tweet, params: NSDictionary?, completion: () ->()) {
        
        POST("1.1/statuses/unretweet/\(tweet.id!).json", parameters:params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject?) -> Void in
            print("Unretweeted tweet: \(tweet.id)")
            tweet.retweeted = 0
            let dict = response as! NSDictionary
            tweet.retweetCount = dict["retweet_count"] as! Int - 1
            print(dict["retweet_count"])
            completion()
            
            
            
            }, failure: { (operation: AFHTTPRequestOperation?, error:NSError) -> Void in
                print("Failed to unretweet: \(error)")
        })
    }
    
    
    func unfavoriteTweet(tweet: Tweet, params: NSDictionary?, completion: () ->()) {
        POST("1.1/favorites/destroy.json", parameters:params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject?) -> Void in
            print("Unfavorited tweet: \(tweet.id)")
            tweet.favorited = 0
            let dict = response as! NSDictionary
            tweet.favoritesCount -= 1
            completion()
            
            }, failure: { (operation: AFHTTPRequestOperation?, error:NSError) -> Void in
                print("Failed to unfavorite: \(error)")
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
                    print(tweet)
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
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            user.dictionary = userDictionary
            user.id = userDictionary["id_str"] as? String
            user.name = userDictionary["name"] as? String
            user.screenName = userDictionary["screen_name"] as? String
            let profileURLString = userDictionary["profile_image_url_https"] as? String
            if let profileURLString = profileURLString {
                user.profileURL = NSURL(string: profileURLString)
            }
            user.tagline = userDictionary["description"] as? String

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
