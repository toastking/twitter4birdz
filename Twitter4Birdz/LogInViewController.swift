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
        
       TwitterClient.sharedInstance.login({ () -> () in
            print("logged in!")
        
            //segue to the tweets screen
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error:NSError) -> () in
            print(error.localizedDescription)
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
