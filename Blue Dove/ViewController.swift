//
//  ViewController.swift
//  Blue Dove
//
//  Created by Lobe Musonda on 7/22/18.
//  Copyright © 2018 Lobe Musonda. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                print("user is signed in")
                
                //Send the user to the HomeTableViewController
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeTableViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarControllerView")
                
                //send the user to the home screen
                self.present(homeTableViewController, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

