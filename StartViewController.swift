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
    
    override func viewDidAppear(_ animated: Bool) {
        if UtiltyFunction.checkInternetConnection() == false {
            self.alert("This app needs active Internet connection", title: "No Internet Connection") {
                (action: UIAlertAction!) in
                    self.performSegue(withIdentifier: "signInSegue", sender: self)
                }
        }
        else{
            self.progressBar.setProgress(0.0, animated: false)
            progressBar.isHidden = false
            DispatchQueue.main.async {
                self.progressBar.setProgress(1.0, animated: true)
            }
            if GIDSignIn.sharedInstance().hasAuthInKeychain(){
                print("Already Sign in")
                GIDSignIn.sharedInstance().signInSilently()
            }
            else {
                print("Not Signed in")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),execute: {
                                self.performSegue(withIdentifier: "signInSegue", sender: self)
                                })
          }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
    }
    
    @IBAction func signIn(_ sender: GIDSignInButton) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
