//
//  ProfileViewController.swift
//  RideGR
//
//  Created by Joseph Stahle on 5/23/19.
//  Copyright © 2019 SWGVSUCIS657. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

import FBSDKLoginKit

class ProfileViewController: UIViewController, LoginButtonDelegate
{

    @IBOutlet var distanceLabel: UILabel!
    let database = Database.database().reference()
    var email: String = ""
    let store = UserDefaults.standard
    @IBOutlet var rankLable: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let btnFBLogin = FBLoginButton()
        btnFBLogin.permissions = ["public_profile", "email", "user_friends"]
        btnFBLogin.center = self.view.center
        btnFBLogin.delegate = self
        
        self.view.addSubview(btnFBLogin)
        
     /*   if AccessToken.current != nil {
            print("Logged in")
        }else{
            print("not logged in")
        } */

        // Do any additional setup after loading the view.
        
        //authenticateUserAndConfigureView()
        
        
        // Displaying Total Distance Ridden from database
        if let e = store.string(forKey: "Email") {
            self.email = e
        }
        
        self.database.child("users\(self.email)").child("distance").observe(.value, with: {(snapshot) in
            if let d = snapshot.value as? Double{
            self.distanceLabel.text = "\(d) miles"
            
            let rank = self.evaluateRank(rank: d)
            self.rankLable.text = rank
                self.rankLable.font = UIFont.boldSystemFont(ofSize: 50.0)
            }else {
                self.rankLable.text = "No Rank"
                self.rankLable.font = UIFont.boldSystemFont(ofSize: 50.0)
            }
        }) { (error) in
            print("ERROR RETRIEVING DISTANCE")
        }
    }
    
    
    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error.localizedDescription)
        }else if result.isCancelled {
            print("User canceled Login")
        }else {
            print("Successful Login")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User logged out");
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem)
    {
        do
        {
            try Auth.auth().signOut()
        }
        catch let error
        {
            print("Failed to sign out", error)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    func authenticateUserAndConfigureView()
    {
        if Auth.auth().currentUser == nil
        {
            DispatchQueue.main.async
            {
                self.performSegue(withIdentifier: "logoutButtonToSignInView", sender: self)
                self.navigationController?.popViewController(animated: true)
                print("Hello")
            }
        }
    }
    
    func evaluateRank(rank: Double) -> String {
        if(rank < 25) {
            return "Prospect"
        } else if (rank < 150) {
            return "Member"
        } else if (rank < 300) {
            return "Enforcer"
        } else if (rank < 600) {
            return "Road Capitan"
        } else if (rank < 1000) {
            return "SGT at Arms"
        } else if (rank < 2000) {
            return "Vice President"
        } else if (rank < 4000) {
            return "President"
        } else {
            return "Founder"
        }
    }
    
    
}
