//
//  SignInViewController.swift
//  Cakes
//
//  Created by Mikhail Seregin on 04.04.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//

import Firebase
import UIKit
import GoogleSignIn

//@objc(SignInViewController)
class SignInViewController: UIViewController, GIDSignInUIDelegate {
  @IBOutlet weak var signInButton: GIDSignInButton!
  var handle: FIRAuthStateDidChangeListenerHandle?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    GIDSignIn.sharedInstance().uiDelegate = self
    //GIDSignIn.sharedInstance().signInSilently()
    
    handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
      if user != nil {
        Analytics.sendLoginEvent()
        self.dismiss(animated: true, completion: nil)
        //self.performSegue(withIdentifier: Constants.Segues.SignInToCl, sender: nil)
      }
    }
  }
  deinit {
    if let handle = handle {
      FIRAuth.auth()?.removeStateDidChangeListener(handle)
    }
  }
}
