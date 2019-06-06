//
//  AddRideViewController.swift
//  RideGR
//
//  Created by Joseph Stahle on 5/31/19.
//  Copyright © 2019 SWGVSUCIS657. All rights reserved.
//

import UIKit
import Firebase

protocol AddRideViewControllerDelegate
{
    func addRide(ride: Ride, distance: Double) -> Void
}

class AddRideViewController: UIViewController
{
    var rideOwner: String = ""
    var rideTitle: String = ""
    var rideDescription: String = ""
    var rideMeetUpLocation: String = ""
    var rideDate: String = ""
    var rideRiderLimit: String = ""
    
    
    @IBOutlet var Distance: UITextField!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var riderLimitLabel: UILabel!
    @IBOutlet weak var riderStepper: UIStepper!
    
    var addRideViewDelegate: AddRideViewControllerDelegate?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var meetUpLocationTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set initial date label as current time
        var currentDate: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MM/dd/YYYY h:mm")
        
        let unformattedDate: Date = Date()
        let formattedDate = dateFormatter.string(from: unformattedDate)
        
        currentDate = formattedDate
        
        dateLabel.text! = currentDate
        
        //Set up stepper
        riderStepper.minimumValue = 1.0
        riderStepper.maximumValue = 200
        riderStepper.stepValue = 1.0
        riderStepper.isContinuous = true
        riderStepper.wraps = true
        riderStepper.autorepeat = true
        
        //Stop editing when clicking view
        let detectTouch: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(detectTouch)
        
        //Add date label tap gesture recognizer
        let tapDateLabel: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapDateLabel))
        dateLabel.isUserInteractionEnabled = true
        dateLabel.addGestureRecognizer(tapDateLabel)
        
        //Hide date picker when clicking view
        let hideDatePicker: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideDatePicker))
        view.addGestureRecognizer(hideDatePicker)
    }
    
    @IBAction func datePicker(_ sender: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MM/dd/YYYY h:mm")
        
        let unformattedDate: Date = datePicker.date
        let formattedDate = dateFormatter.string(from: unformattedDate)
        
        rideDate = formattedDate
        dateLabel.text! = rideDate
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    @objc func hideDatePicker(sender: UITapGestureRecognizer)
    {
        datePicker.isHidden = true
    }
    
    @objc func tapDateLabel(sender: UITapGestureRecognizer)
    {
         datePicker.isHidden = false
    }
    
    @IBAction func riderLimitStepper(_ sender: UIStepper)
    {
        rideRiderLimit = "\(Int(sender.value))"
        riderLimitLabel.text! = rideRiderLimit
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem)
    {
        let currentUser = Auth.auth().currentUser
        
        let store = UserDefaults.standard
        if let e = store.string(forKey: "Email") {
            rideOwner = e
        } else {
            rideOwner = "unknown"
        }
        
        let distance = Double(self.Distance.text!)
      //  rideOwner = currentUser!.email!
        rideTitle = titleTextField.text!
        rideDescription = descriptionTextView.text!
        rideMeetUpLocation = meetUpLocationTextField.text!
        rideDate = dateLabel.text!
        rideRiderLimit = riderLimitLabel.text!
        
        let ride: Ride = Ride(owner: rideOwner, title: rideTitle, description: rideDescription, meetUpLocation: rideMeetUpLocation, date: rideDate)
        addRideViewDelegate?.addRide(ride: ride, distance: distance!)
        
        self.dismiss(animated: true, completion: nil)
    }
}
