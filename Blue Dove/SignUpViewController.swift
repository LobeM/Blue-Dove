//
//  SignUpViewController.swift
//  Blue Dove
//
//  Created by Lobe Musonda on 7/24/18.
//  Copyright © 2018 Lobe Musonda. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUp: UIBarButtonItem!
    
    @IBOutlet weak var errorMessage: UILabel!
    var databaseRef: DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signUp.isEnabled = false
    }
    
    @IBAction func didTapSignup(_ sender: Any) {
        signUp.isEnabled = false
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
            if error != nil {
                let title = "Sign up Failed"
                let message = error?.localizedDescription
                let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ac.addAction(cancelAction)
                self.present(ac, animated: true, completion: nil)
            } else {
                self.errorMessage.text = "Registered Succesfully"
                Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!, completion: { (user, error) in
                    if error == nil {
                        self.databaseRef.child("user_profiles").child((user?.user.uid)!).child("email").setValue(self.email.text!)
                        self.performSegue(withIdentifier: "HandleViewSegue", sender: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func textDidChange(_ sender: UITextField) {
        if (email.text!.count) > 0 && (password.text!.count) > 0 {
            signUp.isEnabled = true
        }
    }
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
