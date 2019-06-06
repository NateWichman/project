//
//  EventTableViewController.swift
//  RideGR
//
//  Created by Joseph Stahle on 5/31/19.
//  Copyright © 2019 SWGVSUCIS657. All rights reserved.
//

import UIKit

import FirebaseDatabase

class EventTableViewController: UITableViewController
{
    var events = [Event]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference()
        
        ref.child("events").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // let rides = snapshot.value as? NSDictionary
            
            for event in snapshot.children {
                let child = event as! DataSnapshot
                let dict = child.value as! NSDictionary
                let e: Event = Event(title: (dict["Title"] as? String)!, description: (dict["Description"] as? String)!,
                                   location: (dict["Location"] as? String)!)
                self.events.append(e)
            }
            
            self.tableView.reloadData()
        
        }) { (error) in
            print(error.localizedDescription)
        }
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "addEventSegue")
        {
            if let addEventViewController = segue.destination as? AddEventViewController
            {
                addEventViewController.addEventViewDelegate = self
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        cell.textLabel?.text = events[indexPath.row].title
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            // Delete the row from the data source
            events.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert
        {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue)
    {
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EventTableViewController: AddEventViewControllerDelegate
{
    func addEvent(event: Event) -> Void
    {
        events.append(event)
        tableView.reloadData()
        
        addEventToDatabase(event: event)
    }
}

extension EventTableViewController {
    func addEventToDatabase(event: Event) {
        let ref = Database.database().reference()
        let timestamp = NSDate()
        ref.child("events/\(timestamp)").setValue([
            "Title": event.title,
            "Description": event.description,
            "Location": event.location])
    }
}
