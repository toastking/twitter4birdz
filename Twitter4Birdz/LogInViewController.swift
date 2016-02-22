//
//  LogInViewController.swift
//  Twitter4Birdz
//
//  Created by Matt on 2/21/16.
//  Copyright © 2016 Matt Del Signore. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInButtonPress(sender: AnyObject) {
        
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com/"), consumerKey: "nIsN2mtfEGI5SkQmU88juuUU1", consumerSecret: "Tbp6jcZsEFSMAT1ZaMRDJqx3Dsz95jnLUlm5VODVJoOugySH2R")
        
        twitterClient.deauthorize() //clear previous sessions to prevent an erro
        twitterClient.fetchRequestTokenWithPath("https://api.twitter.com/oauth/request_token", method: "GET", callbackURL: NSURL(string:"twitterbirds://yolo"), scope: nil, success: {(requestToken:BDBOAuth1Credential!)->Void in
            print("request token obtained")
            
            //now that we have the request token lets authorize the user
            let authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            //now open up the link in mobile safari
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) {(error: NSError!)-> Void in
                print("error:\(error.localizedDescription)")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
