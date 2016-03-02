//
//  tweetCell.swift
//  Twitter4Birdz
//
//  Created by Matt on 2/28/16.
//  Copyright © 2016 Matt Del Signore. All rights reserved.
//

import UIKit
import AFNetworking

class tweetCell: UITableViewCell {

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweettextLabel: UILabel!
    @IBOutlet weak var retweetcountLabel: UILabel!
    @IBOutlet weak var favoritecountLabel: UILabel!
    
    var tweet: Tweet!{
        didSet{
            
            //get the current date
            let date = NSDate()
            let difference = date.timeIntervalSinceDate(tweet.timestamp!)
            
            var timeElapsed = Int(difference)
            var timeUnits = "s"
            if timeElapsed > 60{
                timeElapsed /= 60
                timeUnits = "m"
                if timeElapsed > 60 {
                    timeElapsed /= 60
                    timeUnits = "h"
                    
                    if timeElapsed > 24{
                        timeElapsed /= 24
                        timeUnits = "d"
                        
                        if timeElapsed > 7{
                            timeElapsed /= 7
                            timeUnits = "w"
                        }
                    }
                }
            }
            profileImage.setImageWithURL(tweet.profileImageUrl!)
            accountNameLabel.text = (tweet.name as! String)
            usernameLabel.text = "@" + (tweet.userName as! String)
            timestampLabel.text = String(timeElapsed) + timeUnits
            tweettextLabel.text = (tweet.text as! String)
            retweetcountLabel.text = String(tweet.retweets!)
            favoritecountLabel.text = String(tweet.favorites!)
            
            //change the buttons 
            if tweet.retweeted! == true {
                retweetButton.setImage(UIImage(named: "retweet_pressed.png"), forState: .Normal)
            }
            
            //change the buttons
            if tweet.favorited! == true {
                favoriteButton.setImage(UIImage(named: "favorite_pressed.png"), forState: .Normal)
            }
            
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //set the text wrapping
        tweettextLabel.preferredMaxLayoutWidth = tweettextLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tweettextLabel.preferredMaxLayoutWidth = tweettextLabel.frame.size.width

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
