//
//  ComposeViewController.swift
//  Twitter4Birdz
//
//  Created by Matt on 3/3/16.
//  Copyright © 2016 Matt Del Signore. All rights reserved.
//

import UIKit
import AFNetworking

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var charactersUsedLabel: UIBarButtonItem!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    
    var user: User!
    
    let maxChars = 140
    override func viewDidLoad() {
        super.viewDidLoad()
    
        userLabel.text = "@"+(user.screenName as! String)
        nameLabel.text = (user.name as! String)
        profileImageView.setImageWithURL(user.profileUrl!)
        charactersUsedLabel.title = "140"
        
        textField.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView){
        let charsLeft = maxChars -  (textView.text!.characters.count)
        
        self.charactersUsedLabel.title = String(charsLeft)
        
        if charsLeft < 0 {
            self.charactersUsedLabel.tintColor = UIColor.redColor()
        }else{
            self.charactersUsedLabel.tintColor = UIColor.whiteColor()
        }
        
    }
    
    @IBAction func onTweetButtonPress(sender: AnyObject) {
        //send the tweet
        //check if the tweet has the valid number of characters
        if textField.text != nil{
            if textField.text?.characters.count <= maxChars {
                let text = textField.text
                
                TwitterClient.sharedInstance.tweet(text!, success: { (tweet:Tweet) -> () in
                    print(tweet.text)
                    }, failure: { (error:NSError) -> () in
                        print(error.localizedDescription)
                })
            }
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
