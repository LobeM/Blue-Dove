//
//  LoginViewController.swift
//  Blue Dove
//
//  Created by Lobe Musonda on 7/24/18.
//  Copyright © 2018 Lobe Musonda. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var rootRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTapLogin(_ sender: UIBarButtonItem) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil {
                self.rootRef.child("user_profiles").child((user?.user.uid)!).child("handle").observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
                    if !snapshot.exists() {
                        // user does not have a handle
                        // send the user to the handleView
                        self.performSegue(withIdentifier: "HandleViewSegue", sender: nil)
                    } else {
                        self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
                    }
                })
            } else {
                let title = "Login Failed"
                let message = error?.localizedDescription
                let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Try again", style: .cancel, handler: nil)
                ac.addAction(cancelAction)
                self.present(ac, animated: true, completion: nil)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
