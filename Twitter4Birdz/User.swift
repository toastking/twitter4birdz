//
//  User.swift
//  Twitter4Birdz
//
//  Created by Matt on 2/23/16.
//  Copyright © 2016 Matt Del Signore. All rights reserved.
//

import UIKit

class User: NSObject {

    var name:NSString?
    var screenName: NSString?
    var profileUrl: NSURL?
    var profileDescription: NSString?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"]as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        profileDescription = dictionary["description"] as? String
        
        if let profileUrlString = profileUrlString{
            profileUrl = NSURL(string: profileUrlString)
        }
    }
    
}
