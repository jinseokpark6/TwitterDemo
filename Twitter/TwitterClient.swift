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

    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(
                baseURL: twitterBaseUrl,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func openURL(url: NSURL) {
        

        TwitterClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            print("Got the access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                print("user: \(response)")
                
                }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
                    print("error getting user")
            })
            
            TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                print("Timeline: \(response)")
                
                }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
                    print("error getting timeline")
            })

            
            }) { (error: NSError!) -> Void in
                print("Failed to receive access token")
        }

    }
    
    func login() {
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cputwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print ("got the request token.")
            
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (error: NSError!) -> Void in
                print ("failed to get request token.")
                //                self.loginCompletion?(user: nil, error: error)
                
                
        }

    }


}
