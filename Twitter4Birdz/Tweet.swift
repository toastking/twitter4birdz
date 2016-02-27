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
    
    init(dictionary:NSDictionary){
        text = dictionary["text"] as? String
        retweets = (dictionary["retweet_count"] as? Int) ?? 0 //if this key exists, use it, otherwise use 0
        favorites = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            //format the date
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
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
