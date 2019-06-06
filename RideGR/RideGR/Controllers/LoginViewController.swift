//
//  LoginViewController.swift
//  RideGR
//
//  Created by Joseph Stahle on 5/16/19.
//  Copyright © 2019 SWGVSUCIS657. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController
{
    var email: String = ""
    var password: String = ""
    
    //Text Fields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //Buttons
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Dismiss keyboard when tapping on safe area
        let detectViewTouch: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(detectViewTouch)
        
        //Make this View Controller the delegate of the text fields
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Check if user logged in already
        if (Auth.auth().currentUser != nil)
        {
            performSegue(withIdentifier: "signInButtonToProfileView", sender: self)
            print("user already logged in")
        }
    }
    
    @IBAction func signInButton(_ sender: UIButton)
    {
        email = emailTextField.text!
        password = passwordTextField.text!

        if(validateTextFields())
        {
            Auth.auth().signIn(withEmail: email, password: password) {(result, error) in
                if let error = error
                {
                    print("Failed to sign in with error: ", error.localizedDescription)
                    return
                }
            }
            print("Sign in successful")
            
            // SAVING EMAIL TO LOCAL STORAGE
            let defaults = UserDefaults.standard
            let key = email.replacingOccurrences(of: ".", with: "")
            defaults.set(key, forKey: "Email")
            
            
            performSegue(withIdentifier: "signInButtonToProfileView", sender: self)
        }
        else
        {
            print("Sign in unsuccessful")
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton)
    {
        performSegue(withIdentifier: "registerButtonToRegistrationView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "registerButtonToRegistrationView")
        {
            if let registrationViewController = segue.destination as? RegistrationViewController
            {
                //email = self.emailTextField.text!
                //registrationViewController.email = email
            }
        }
    }

    /////////////////////////////////////////////Helper Functions/////////////////////////////////////////////////////
    func validateTextFields() -> Bool
    {
        var validPassword = false
        
        //Only letters and numbers, must start with letter
        let passwordRegEx = "^[a-zA-Z]+[a-zA-Z0-9]*"
        
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
        
        return validPassword
    }

    @objc func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if (textField == emailTextField)
        {
            passwordTextField.becomeFirstResponder()
        }
        else if(textField == passwordTextField)
        {
            signInButton(signInButton)
        }
        return true
    }
}
