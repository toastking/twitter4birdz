//
//  TweetsViewController.swift
//  Twitter4Birdz
//
//  Created by Matt on 2/27/16.
//  Copyright © 2016 Matt Del Signore. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets :[Tweet]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetch my tweets
        TwitterClient.sharedInstance.homeTimeline({ (tweets:[Tweet]) -> () in
            //store tweets and reload tableview
            self.tweets = tweets
            
            for tweet in tweets{
                print(tweet.text)
            }
            }) { (error:NSError) -> () in
                print(error.localizedDescription)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
