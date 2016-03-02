//
//  User.swift
//  Twitter4Birdz
//
//  Created by Matt on 2/23/16.
//  Copyright © 2016 Matt Del Signore. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let userDidLogoutStr = "UserDidLogout"
    
    var name:NSString?
    var screenName: NSString?
    var profileUrl: NSURL?
    var profileHeaderUrl: NSURL?
    var profileDescription: NSString?
    
    var dictionary: NSDictionary!
    
    var tweetsCount: Int?
    var followerCount: Int?
    var followingCount: Int?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"]as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        let profileHeaderString = dictionary["profile_background_image_url_https"] as? String
        profileDescription = dictionary["description"] as? String
        
        self.dictionary = dictionary
        if let profileUrlString = profileUrlString{
            profileUrl = NSURL(string: profileUrlString)
        }
        
        if let profileHeaderString = profileHeaderString{
            profileHeaderUrl = NSURL(string: profileHeaderString)
        }
        
        tweetsCount = dictionary["statuses_count"] as? Int
        followerCount = dictionary["follower_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        
    }
    
    static var cUser : User?
    
    class var currentUser: User?{
        get {
        
        if cUser == nil{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let currentUserData = defaults.objectForKey("currentUser") as? NSData
        
        if let currentUserData = currentUserData{
        let dictionary = try! NSJSONSerialization.JSONObjectWithData(currentUserData, options: [])
        
        cUser = User(dictionary: dictionary as! NSDictionary)
        }
        }
        
        return cUser
        
        }
        set(user) {
            cUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user{
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary, options: [])
                defaults.setObject(data, forKey: "currentUser")
            }else{
                //store the nil in storage
                defaults.setObject(nil, forKey: "currentUser")
            }
            
            //save the object
            defaults.synchronize()
        }
    }
    
}
