//
//  TweetsViewController.swift
//  Twitter4Birdz
//
//  Created by Matt on 2/27/16.
//  Copyright © 2016 Matt Del Signore. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tweets :[Tweet]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up the tablview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension //set thiis so autolayout will decide the height
        tableView.estimatedRowHeight = 200
        
        //add the refresh controller
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        //fetch my tweets
        TwitterClient.sharedInstance.homeTimeline({ (tweets:[Tweet]) -> () in
            //store tweets and reload tableview
            self.tweets = tweets
            
            //reload the table 
            self.tableView.reloadData()
            }) { (error:NSError) -> () in
                print(error.localizedDescription)
        }

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    func refreshAction(refreshControl: UIRefreshControl){
        //fetch my tweets
        TwitterClient.sharedInstance.homeTimeline({ (tweets:[Tweet]) -> () in
            //store tweets and reload tableview
            self.tweets = tweets
            
            //reload the table
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            }) { (error:NSError) -> () in
                print(error.localizedDescription)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //handle the detail segue
        if segue.identifier == "DetailSegue" {
            let cell = sender as! tweetCell //cast the cell the segue was sent from
            if let indexPath = tableView.indexPathForCell(cell){
                let detailController = segue.destinationViewController as! DetailViewController
                detailController.tweet = tweets[indexPath.row] //set the tweet to fill in the index path view controller 
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
        
        if segue.identifier == "tweetToProfileSegue"{
            let view = sender!.superview //cast the cell the segue was sent from
            let cell = view!!.superview as! tweetCell
            if let indexPath = tableView.indexPathForCell(cell){
                let profileController = segue.destinationViewController as! ProfileViewController
                let tweet = tweets[indexPath.row]
                profileController.screenName = tweet.userName as! String//set the tweet to fill in the index path view controller
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        }
    }

}