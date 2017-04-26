//
//  ProfileViewController.swift
//  Cakes
//
//  Created by Михаил Серёгин on 25.04.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePhone: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImage2: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBAction func logOut(_ sender: UIButton) {
        let fireBaseAuth = FIRAuth.auth()
            do {
                try fireBaseAuth?.signOut()
                performSegue(withIdentifier: "SignOut", sender: self)
            }
            catch let signOutError as NSError {
                print ("Error signing out: \(signOutError.localizedDescription)")
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FIRAuth.auth()?.currentUser == nil {
            performSegue(withIdentifier: "SignOut", sender: self)
        }

        if FIRAuth.auth()?.currentUser != nil {
            profileName.text = FIRAuth.auth()?.currentUser?.displayName
            profileEmail.text = FIRAuth.auth()?.currentUser?.email
            let imageURL = FIRAuth.auth()?.currentUser?.photoURL
            let data = try? Data(contentsOf: imageURL!)
            profileImage.image = UIImage(data: data!)
            profileImage2.image = UIImage(data: data!)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
