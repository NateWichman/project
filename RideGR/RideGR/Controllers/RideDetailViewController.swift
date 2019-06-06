//
//  RideDetailViewController.swift
//  RideGR
//
//  Created by Joseph Stahle on 6/5/19.
//  Copyright © 2019 SWGVSUCIS657. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RideDetailViewController: UIViewController
{
    var titleText: String = ""
    var descriptionText: String = ""
    var meetUpLocationText: String = ""
    var dateText: String = ""
    let database = Database.database().reference()
    let store = UserDefaults.standard
    var email: String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var meetUpLocationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var `switch`: UISwitch!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let e = store.string(forKey: "Email") {
            self.email = e
        }
        
        // Getting whether or not the user is signed up from the database
        self.database.child("attending/\(self.email)/\(self.titleText)").observeSingleEvent(of: .value, with: { (snapshot) in
            let result = snapshot.value as? String
            
            // Setting the switch to on if the user is attending the ride (got from database)
            if (result == "true") {
                self.switch.setOn(true, animated: false)
            } else {
                self.switch.setOn(false, animated: false)
            }
        })

        // Do any additional setup after loading the view.
        titleLabel.text! = titleText
        descriptionLabel.text! = descriptionText
        meetUpLocationLabel.text! = meetUpLocationText
        dateLabel.text! = dateText
    }
    
    @IBAction func switchChanged(_ sender: Any) {
        if (self.switch.isOn) {
            // Updating database so that rider is attending the ride
            self.database.child("attending/\(self.email)").child("\(self.titleText)")
            .setValue("true")
            
            // Getting the distance of this ride
            self.database.child("rides/\(self.titleText)").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                       let ride = snapshot.value as! NSDictionary
                       let distance = (ride["Distance"] as? Double)!
                
                // Updating user's profile
               
                self.database.child("users\(self.email)").child("distance").observeSingleEvent(of: .value, with: {(snapshot) in
                    if var d = snapshot.value as? Double {
                        self.database.child("users\(self.email)").child("distance").setValue(distance + d)
                        print(d)
                    }else {
                        self.database.child("users\(self.email)").child("distance").setValue(distance)
                    }
                }) { (error) in
                    self.database.child("users\(self.email)").child("distance").setValue(distance)
                }
                }) { (error) in
                    print(error.localizedDescription)
            }
        } else {
            self.database.child("attending/\(self.email)").child("\(self.titleText)")
                .setValue("false")
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
