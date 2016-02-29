//
//  Tweet.swift
//  Twitter
//
//  Created by WUSTL STS on 2/21/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var id: Int?
    var text: String?
    var name: String?
    var screenName: String?
    var timeStamp: NSDate?
    var profileUrl: NSURL?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var retweeted: Int?
    var favorited: Int?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        id = dictionary["id"] as? Int
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        retweeted = dictionary["retweeted"] as? Int
        favorited = dictionary["favorited"] as? Int
        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.dateFromString(timeStampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
            print(dictionary)
        }
        
        return tweets
    }

}
