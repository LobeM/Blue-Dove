//
//  HandleViewController.swift
//  Blue Dove
//
//  Created by Lobe Musonda on 7/25/18.
//  Copyright © 2018 Lobe Musonda. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HandleViewController: UIViewController {

    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var handle: UITextField!
    @IBOutlet weak var startTweeting: UIBarButtonItem!
    
    var user: AnyObject!
    var rootRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        user = Auth.auth().currentUser
    }

    @IBAction func didTapStartTweeting(_ sender: UIBarButtonItem) {
        let handle = rootRef.child("handles").child(self.handle.text!).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if !snapshot.exists() {
                // Update the handle in the user_profiles and in the handle mode
                self.rootRef.child("user_profiles").child(self.user!.uid).child("handle").setValue(self.handle.text!.lowercased())
                
                // Update the name of the user
                self.rootRef.child("user_profiles").child(self.user!.uid).child("name").setValue(self.fullName.text!)
                
                // Update the handle in the handle node
                self.rootRef.child("handles").child(self.handle.text!.lowercased()).setValue(self.user?.uid)
                
                //send the user to the home screen
                self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
                
            } else {
                let title = "Not available"
                let message = "Handle already in use"
                let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
                ac.addAction(cancelAction)
                self.present(ac, animated: true, completion: nil)
            }
        }
        
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
