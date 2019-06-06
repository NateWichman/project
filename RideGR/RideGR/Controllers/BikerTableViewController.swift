//
//  BikerTableViewController.swift
//  RideGR
//
//  Created by Joseph Stahle on 6/5/19.
//  Copyright © 2019 SWGVSUCIS657. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseDatabase

class BikerTableViewController: UITableViewController
{
    var bikers = [Biker]()
    let database = Database.database().reference()
    var email: String = ""
    let store = UserDefaults.standard
    //let bikers: [String] = ["one", "two"]
    
    var currentRow: Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        bikers.append(Biker(bikername: "one", motorcycle: "two", biography: "three"))

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.tableView.reloadData()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bikers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
        
        //cell.textLabel?.text = bikers[indexPath.row].bikername
        cell.textLabel?.text = self.bikers[indexPath.row].bikername
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            // Delete the row from the data source
            //bikers.remove(at: indexPath.row)
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
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

/*
extension RideTableViewController
{
    func getMembersFromDatabase(member: Member)
    {
        let ref = Database.database().reference()
        let timestamp = NSDate()
        ref.child("rides/\(timestamp)").setValue([
            "Title": ride.title,
            "Description": ride.description,
            "MeetUpLocation": ride.meetUpLocation])
    }
}
 */
