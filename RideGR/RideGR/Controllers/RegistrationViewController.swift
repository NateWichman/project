//
//  RegistrationViewController.swift
//  RideGR
//
//  Created by Joseph Stahle on 5/16/19.
//  Copyright © 2019 SWGVSUCIS657. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegistrationViewController: UIViewController
{
    var email: String = ""
    var bikername: String = ""
    var password: String = ""
    var verifyPassword: String = ""
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bikernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Populate email from sign in screen
        self.emailTextField.text! = ""
        
        //Dismiss keyboard when tapping off text fields
        let detectTouch = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(detectTouch)
        
        //Make this controller the delegate of the text fields
        self.emailTextField.delegate = self
        self.bikernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.verifyPasswordTextField.delegate = self
    }
  
    @IBAction func cancelButton(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButton(_ sender: UIButton)
    {
        //emailTextField.text! = email
        email = emailTextField.text!
        bikername = bikernameTextField.text!
        password = passwordTextField.text!
        verifyPassword = verifyPasswordTextField.text!
        
        if(validateTextFields())
        {
            Auth.auth().createUser(withEmail: email, password: password)
            {
                authResult, error in
                
                if let error = error
                {
                    print("Failed to sign up user with error: ", error.localizedDescription)
                    print("Sign uppppppppppp unsuccessful")
                    return
                }
                guard let userID = authResult?.user.uid else {return}
                let databaseValues: Dictionary<String, String> = ["Email": self.email, "Bikername": self.bikername]
                Database.database().reference().child("users").child(userID).updateChildValues(databaseValues, withCompletionBlock: {(error, ref) in
                    if let error = error
                    {
                        print("Failed to update database values with error: ", error.localizedDescription)
                        return
                    }
                    //print("Sign up unsuccessful")
                })
            }
            performSegue(withIdentifier: "registerButtonToMain", sender: self)
        }
    }
    
    //////////////////////////////////////////////////Helper Functions/////////////////////////////////////////////////////
    func validateTextFields() -> Bool
    {
        var validBikername = false
        var validPassword = false
        var validVerifyPassword = false
        
        //Only letters and numbers, must start with letter
        let bikernameRegEx = "^[a-zA-Z]+[a-zA-Z0-9]*"
        let passwordRegEx = "^[a-zA-Z]+[a-zA-Z0-9]*"
        
        if(bikername != "")
        {
            let bikernamePredicate = NSPredicate(format:"SELF MATCHES %@", bikernameRegEx)
            validBikername = bikernamePredicate.evaluate(with: bikername)
        }
        else
        {
            print("Enter a Bikername")
        }
        
        if(!validBikername)
        {
            print("Invalid Bikername!")
        }
        
        if(password != "")
        {
            let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
            validPassword = passwordPredicate.evaluate(with: password)
        }
        else
        {
            print("Enter Password")
        }
        
        if (!validPassword)
        {
            print("Invalid Password!")
        }
        
        if(password == verifyPassword)
        {
            validVerifyPassword = true
        }
        else
        {
            print("Password and Verify Password do not match!")
        }
        return validBikername && validPassword && validVerifyPassword
    }
    
    @objc func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
}

extension RegistrationViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if (textField == emailTextField)
        {
            bikernameTextField.becomeFirstResponder()
        }
        else if(textField == bikernameTextField)
        {
            passwordTextField.becomeFirstResponder()
        }
        else if(textField == passwordTextField)
        {
            verifyPasswordTextField.becomeFirstResponder()
        }
        else if(textField == verifyPasswordTextField)
        {
            registerButton(registerButton)
        }
        return true
    }
}
