//
//  ProfileViewController.swift
//  Twitter4Birdz
//
//  Created by Matt on 3/2/16.
//  Copyright © 2016 Matt Del Signore. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    
    var user:User!
    var tweets: [Tweet]!
    var screenName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension //set thiis so autolayout will decide the height
        tableView.estimatedRowHeight = 200

        TwitterClient.sharedInstance.getUser(screenName, success: { (user:User) -> () in
            self.user = user
            //set the user's attributes to the labels
            self.headerImageView.setImageWithURL(user.profileHeaderUrl!)
            self.userNameLabel.text = user.screenName as! String
            self.profileImageView.setImageWithURL(user.profileUrl!)
            self.nameLabel.text = user.name as! String
            self.tweetCountLabel.text = String(user.tweetsCount!)
            self.followingCount.text = String(user.followingCount!)
            self.followerCount.text = String(user.followingCount!)
            
            print(user)
            
            //fetch the tweets for the user
            TwitterClient.sharedInstance.userTimeline(user.screenName as! String, success: { (tweets:[Tweet]) -> () in
                //store tweets and reload tableview
                self.tweets = tweets
                
                //reload the table
                self.tableView.reloadData()
                }) { (error:NSError) -> () in
                    print(error.localizedDescription)
            }
            
            }) { (error:NSError) -> () in
                print(error.localizedDescription)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tweets != nil{
            return tweets.count
        }else{
            return 0
        }
        
    }
    
    @IBAction func onFavoritePress(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! tweetCell
        
        let indexPath = tableView.indexPathForCell(cell) //get indexp[ath of the cell we selected
        
        let tweet = tweets[(indexPath?.row)!] //get the tweet from our array
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
        
        tableView.reloadData()
    }
    @IBAction func onRetweetPress(sender: AnyObject?) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! tweetCell
        
        let indexPath = tableView.indexPathForCell(cell) //get indexp[ath of the cell we selected
        
        let tweet = tweets[(indexPath?.row)!] //get the tweet from our array
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
        tableView.reloadData()
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! tweetCell
        //assign the business
        cell.tweet = tweets[indexPath.row]
        return cell
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
