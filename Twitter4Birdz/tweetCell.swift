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

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweettextLabel: UILabel!
    @IBOutlet weak var retweetcountLabel: UILabel!
    @IBOutlet weak var favoritecountLabel: UILabel!
    
    var tweet: Tweet!{
        didSet{
            profileImage.setImageWithURL(tweet.profileImageUrl!)
            accountNameLabel.text = (tweet.name as? String)
            usernameLabel.text = tweet.userName as? String
            timestampLabel.text = tweet.timestamp as? String
            tweettextLabel.text = tweet.text as? String
            retweetcountLabel.text = tweet.retweets as? String
            favoritecountLabel.text = (tweet.favorites as? String)
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
