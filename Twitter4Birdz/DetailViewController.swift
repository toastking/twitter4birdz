//
//  DetailViewController.swift
//  Twitter4Birdz
//
//  Created by Matt on 3/1/16.
//  Copyright © 2016 Matt Del Signore. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {

    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweettextLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileView: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    var tweet:Tweet! //the tweet model we will use to populate our view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(tweet.profileImageUrl!)
        profileView.setImageWithURL(tweet.profileImageUrl!)
        nameLabel.text = (tweet.name as! String)
        usernameLabel.text = (tweet.userName as! String)
        tweettextLabel.text = (tweet.text as! String)
        timestampLabel.text = String(tweet.timestamp!)
        retweetsLabel.text = String(tweet.retweets!)
        favoritesLabel.text = String(tweet.favorites!)
        // Do any additional setup after loading the view.
        tweettextLabel.preferredMaxLayoutWidth = tweettextLabel.frame.size.width
        
    }
    
    @IBAction func onFavoritePress(sender: AnyObject) {
        let id = tweet.id
        
        //now send the request
        TwitterClient.sharedInstance.favorite(id!, success: { (tweet:Tweet) -> () in
            print("successful favorite!")
            print(tweet.text)
            }) { (error:NSError) -> () in
                print("error with favorite")
                print(error.localizedDescription)
        }
        
        //update the count
        tweet.favorites! += 1
        tweet.favorited = true
    }
    @IBAction func onRetweetPress(sender: AnyObject?) {
        let id = tweet.id
        
        //now send the request
        TwitterClient.sharedInstance.retweet(id!, success: { (tweet:Tweet) -> () in
            print("successful retweet!")
            print(tweet.text)
            }) { (error:NSError) -> () in
                print("error with retweet")
                print(error.localizedDescription)
        }
        
        //update the count
        tweet.retweets! += 1
        tweet.retweeted = true
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
