//
//  SigInController.swift
//  DoctorMap
//
//  Created by Kushagra Gupta on 17/08/16.
//  Copyright © 2016 Kushagra Gupta. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, GIDSignInUIDelegate {


    @IBOutlet weak var signInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 10
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {

    }
    
}