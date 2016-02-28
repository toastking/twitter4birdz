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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
