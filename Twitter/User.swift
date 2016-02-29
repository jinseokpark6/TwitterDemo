//
//  User.swift
//  Twitter
//
//  Created by WUSTL STS on 2/21/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var id: String?
    var name: String?
    var screenName: String?
    var profileURL: NSURL?
    var tagline: String?
    var following: Int?
    var followers: Int?
    var statuses: Int?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        id = dictionary["id_str"] as? String
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = NSURL(string: profileURLString)
        }
        tagline = dictionary["description"] as? String
        statuses = dictionary["statuses_count"] as? Int
        following = dictionary["friends_count"] as? Int
        followers = dictionary["followers_count"] as? Int

    }
    
    
    static let userDidLogoutNotification = "UserDidLogout"

    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
        
                let userData = defaults.objectForKey("currentUserData") as? NSData
        
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
        
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])

                defaults.setObject(data, forKey: "currentUserData")
                defaults.synchronize()
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
        }
    }
}
