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
    
    
    //handle posting a tweet
    func tweet(tweetText : String, success: (Tweet) -> (), failure: (NSError) -> ()){
        POST("1.1/statuses/update.json", parameters: ["status":tweetText], progress: nil,success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            //success functions
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success(tweet)
            }) { (errorTask:NSURLSessionDataTask?, error:NSError) -> Void in
                //error task
                failure(error)
        }
    }

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
    
    //function fetches a user timeline
    func userTimeline(screenName: String, success: ([Tweet])->(), failure: (NSError)->()){
        GET("1.1/statuses/user_timeline.json", parameters: ["screen_name": screenName, "include_rts": true], progress: nil, success: { (Task: NSURLSessionDataTask, response:AnyObject?) -> Void in
            let tweetDict = response as! [NSDictionary]
            let tweets = Tweet.TweetsWithArray(tweetDict)
            
            //run the success closure function
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                //run the failure closure function
                failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError)->()){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            let userDict = response as! NSDictionary
            
            //initialize a user object
            let user = User(dictionary: userDict)
            
            //call the success function
            success(user)
            
            print("name: \(user.name)")
            print("screen name: \(user.screenName)")
            print("description: \(user.profileDescription)")
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                failure(error)
        })
    }
    
    func getUser(screenName: String, success: (User) -> (), failure: (NSError)->()){
        GET("1.1/users/show.json", parameters: ["screen_name":screenName], progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
            let userDict = response as! NSDictionary
            
            //initialize a user object
            let user = User(dictionary: userDict)
            
            //call the success function
            success(user)
            
            print("name: \(user.name)")
            print("screen name: \(user.screenName)")
            print("description: \(user.profileDescription)")
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                failure(error)
        })
    }
    
    func retweet(id:Int,success: (Tweet)->(), failure: (NSError)->()){
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, constructingBodyWithBlock: nil, progress: nil, success: { (task:NSURLSessionDataTask, tweetjson:AnyObject?) -> Void in
            let tweetdict = tweetjson as! NSDictionary
            let tweet = Tweet(dictionary: tweetdict)
            
            success(tweet)
            
            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                print(error.localizedDescription)
                failure(error)
        }
    }
    
    func favorite(id:Int,success: (Tweet)->(), failure: (NSError)->()){
        POST("1.1/favorites/create.json", parameters: ["id":"\(id)"], constructingBodyWithBlock: nil, progress: nil, success: { (task:NSURLSessionDataTask, tweetjson:AnyObject?) -> Void in
            let tweetdict = tweetjson as! NSDictionary
            let tweet = Tweet(dictionary: tweetdict)
            
            success(tweet)
            
            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                print(error.localizedDescription)
                failure(error)
        }
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
    
    func logout(){
        //handle logout
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutStr, object: nil)
    }
    
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        TwitterClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("token recieved")
            
            //get the current account for the user
            self.currentAccount({ (user:User) -> () in
                //set the user using the setter in the user class
                User.currentUser = user
                self.loginSuccess?()
                
                }, failure: { (error:NSError) -> () in
                    self.loginFailure?(error)
            })
            
            
            
            
            }) { (error: NSError!) -> Void in
                print("error:\(error.localizedDescription)")
                self.loginFailure!(error)
        }

    }
}
