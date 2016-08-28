//
//  StartViewController.swift
//  
//
//  Created by Kushagra Gupta on 25/08/16.
//
//

import UIKit

class StartViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var signInButton: GIDSignInButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        if UtiltyFunction.checkInternetConnection() == false {
            self.alert("This app needs active Internet connection", title: "No Internet Connection") {
                (action: UIAlertAction!) in
                    self.performSegueWithIdentifier("signInSegue", sender: self)
                }
        }
        else{
            self.progressBar.setProgress(0.0, animated: false)
            progressBar.hidden = false
            dispatch_async(dispatch_get_main_queue(), {
                self.progressBar.setProgress(1.0, animated: true)
            })
            if GIDSignIn.sharedInstance().hasAuthInKeychain(){
                print("Already Sign in")
                GIDSignIn.sharedInstance().signInSilently()
            }
            else {
                print("Not Signed in")
                
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))),
                                   dispatch_get_main_queue(),{
                                    self.performSegueWithIdentifier("signInSegue", sender: self)
                                   })
          }
        }
    }
    
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
    }
    
    @IBAction func signIn(sender: GIDSignInButton) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
