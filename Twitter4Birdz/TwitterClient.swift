//
//  TwitterClient.swift
//  Twitter4Birdz
//
//  Created by Matt on 2/23/16.
//  Copyright © 2016 Matt Del Signore. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com/"), consumerKey: "nIsN2mtfEGI5SkQmU88juuUU1", consumerSecret: "Tbp6jcZsEFSMAT1ZaMRDJqx3Dsz95jnLUlm5VODVJoOugySH2R")
    var loginSuccess: (() -> ())?
    var loginFailure : ((NSError)->())?

    //function fetches the home timeline
    func homeTimeline(success: ([Tweet])->(), failure: (NSError)->()){
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (Task: NSURLSessionDataTask, response:AnyObject?) -> Void in
            let tweetDict = response as! [NSDictionary]
            let tweets = Tweet.TweetsWithArray(tweetDict)
            
            //run the success closure function
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                //run the failure closure function
                failure(error)
        })
    }
    
    func currentAccount(){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            let userDict = response as! NSDictionary
            
            //initialize a user object
            let user = User(dictionary: userDict)
            
            print("name: \(user.name)")
            print("screen name: \(user.screenName)")
            print("description: \(user.profileDescription)")
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                
        })
    }
    
    func login(sucess: ()->(), failure:(NSError)->() ){
        loginFailure = failure
        loginSuccess = sucess
        
        TwitterClient.sharedInstance.deauthorize() //clear previous sessions to prevent an erro
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("https://api.twitter.com/oauth/request_token", method: "GET", callbackURL: NSURL(string:"twitterbirds://yolo"), scope: nil, success: {(requestToken:BDBOAuth1Credential!)->Void in
            print("request token obtained")
            
            //now that we have the request token lets authorize the user
            let authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            //now open up the link in mobile safari
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) {(error: NSError!)-> Void in
                self.loginFailure?(error)
        }
    }
    
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        TwitterClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("token recieved")
            
            self.loginSuccess!()
            
            
            }) { (error: NSError!) -> Void in
                print("error:\(error.localizedDescription)")
                self.loginFailure!(error)
        }

    }
}
