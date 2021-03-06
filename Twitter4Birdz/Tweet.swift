//
//  Tweet.swift
//  Twitter4Birdz
//
//  Created by Matt on 2/23/16.
//  Copyright © 2016 Matt Del Signore. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: NSString?
    var retweets: Int?
    var favorites: Int?
    var timestamp: NSDate?
    var profileImageUrl: NSURL?
    var userName: NSString?
    var name: NSString?
    var userID: String?
    var dateString: NSString?
    var id: Int?
    //whether or not the user favorited or retweeted a tweet
    var favorited: Bool?
    var retweeted: Bool?
    
    init(dictionary:NSDictionary){
        text = dictionary["text"] as? String
        retweets = (dictionary["retweet_count"] as? Int) ?? 0 //if this key exists, use it, otherwise use 0
        favorites = (dictionary["favorite_count"] as? Int) ?? 0
        id = (dictionary["id"] as! Int)
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            //format the date
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
            dateString = formatter.stringFromDate(timestamp!)
        }
        
        let userDictionary = dictionary["user"] as! NSDictionary
        
        //get the profile image url
        profileImageUrl = NSURL( string: userDictionary["profile_image_url"] as! String)
        
        userName = userDictionary["screen_name"] as! String
        
        userID = userDictionary["id_str"] as! String
        
        name = userDictionary["name"] as! String
        
        favorited = (dictionary["favorited"] as! Bool)
        retweeted = (dictionary["retweeted"] as! Bool)
    }
    
    class func TweetsWithArray(dictionaries: [NSDictionary])->[Tweet]{
        var tweets = [Tweet]()
        
        for dict in dictionaries{
            let tweet = Tweet(dictionary: dict)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
