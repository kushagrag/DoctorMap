//
//  StartViewController.swift
//  
//
//  Created by Kushagra Gupta on 25/08/16.
//
//

import UIKit

class StartViewController: UIViewController {

        @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.setProgress(0.0, animated: false)
        dispatch_async(dispatch_get_main_queue(), {
            self.progressBar.setProgress(1.0, animated: true)
        })
        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            print("Already Sign in")
            GIDSignIn.sharedInstance().signInSilently()
        }
        else {
            print("Not Signed in")
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * Int64(NSEC_PER_SEC)), dispatch_get_main_queue(), {
                   self.performSegueWithIdentifier("signInSegue", sender: nil)
               })
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
