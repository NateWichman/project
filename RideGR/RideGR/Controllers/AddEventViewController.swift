//
//  AddEventViewController.swift
//  RideGR
//
//  Created by Joseph Stahle on 6/1/19.
//  Copyright © 2019 SWGVSUCIS657. All rights reserved.
//

import UIKit

protocol AddEventViewControllerDelegate
{
    func addEvent(event: Event) -> Void
}

class AddEventViewController: UIViewController
{
    var titlee: String = ""
    var descriptionn: String = ""
    var location: String = ""
    
    var addEventViewDelegate: AddEventViewControllerDelegate?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem)
    {
        titlee = titleTextField.text!
        descriptionn = descriptionTextField.text!
        location = locationTextField.text!
        
        let event: Event = Event(title: titlee, description: descriptionn, location: location)
        addEventViewDelegate?.addEvent(event: event)
        
        self.dismiss(animated: true, completion: nil)
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
