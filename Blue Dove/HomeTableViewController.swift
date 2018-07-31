//
//  HomeTableViewController.swift
//  Blue Dove
//
//  Created by Lobe Musonda on 7/26/18.
//  Copyright © 2018 Lobe Musonda. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeTableViewController: UITableViewController, UITextViewDelegate {

    var databaseRef = Database.database().reference()
    var loggedInUser: AnyObject!
    var loggedInUserData: AnyObject!
    var tweets: AnyObject!
    var numberOfTweets = [AnyObject?]()
    
    @IBOutlet weak var aivLoading: UIActivityIndicatorView!
    @IBOutlet var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loggedInUser = Auth.auth().currentUser
        
        // Get the logged in user details
        databaseRef.child("user_profiles").child(loggedInUser!.uid).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            
            // Store the logged in users details into the variable
            let getData = snapshot.value as? [String:Any]
            self.loggedInUserData = getData as AnyObject
            
            //get all the tweets made by the user
            self.databaseRef.child("tweets/\(self.loggedInUser!.uid)").observe(.childAdded, with: { (snapshot: DataSnapshot) in
                self.numberOfTweets.append(snapshot)
                let getTweets = snapshot.value as? [String:Any]
                self.tweets = getTweets as AnyObject
                self.homeTableView.insertRows(at: [NSIndexPath(row:0, section:0) as IndexPath], with: UITableViewRowAnimation.automatic)
                
                self.aivLoading.stopAnimating()
            }){(error) in
                print("error getting tweets: ", error.localizedDescription)
            }
        }
        
        if numberOfTweets.count == 0 {
            self.aivLoading.stopAnimating()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.numberOfTweets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewTableViewCell", for: indexPath) as! HomeViewTableViewCell
        //let oneStepBelow = tweets[(self.tweets.count - 1) - indexPath.row] as! [AnyObject]
        //let secondStep = oneStepBelow[0].value(forKey: "name") as! String
        
//        cell.configure(profilePic: nil, name: self.loggedInUserData.value(forKey: "name") as! String, handle: self.loggedInUserData.value(forKey: "handle") as! String, tweet: tweet)
        
        //let tweet = (tweets[(self.tweets.count-1) - indexPath.row] as AnyObject).value(forKey: "text") as! String
        let name = self.loggedInUserData["name"] as! String
        let handle = self.loggedInUserData["handle"] as! String
        let tweet = self.tweets["text"] as! String
        
        cell.configure(profilePic: nil, name: name, handle: handle, tweet: tweet)
//        cell.configure(profilePic: nil, name: "nun", handle: "nun", tweet: "nun")
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
