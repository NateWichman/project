//
//  RideTableViewController.swift
//  RideGR
//
//  Created by Joseph Stahle on 5/31/19.
//  Copyright © 2019 SWGVSUCIS657. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RideTableViewController: UITableViewController
{
    var rides = [Ride]()
    
    //Keeps track of selected row in table
    var currentRow: Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let ref = Database.database().reference()
        
        ref.child("rides").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // let rides = snapshot.value as? NSDictionary
            
            for ride in snapshot.children {
                let child = ride as! DataSnapshot
                let dict = child.value as! NSDictionary
                let r: Ride = Ride(owner: "OWNER", title: (dict["Title"] as? String)!, description: (dict["Description"] as? String)!,
                                   meetUpLocation: (dict["MeetUpLocation"] as? String)!, date: "6/1/19")
                self.rides.append(r)
            }
            
            self.tableView.reloadData()
          /*  let ride: Ride = Ride(title: titlee, description: descriptionn, meetUpLocation: meetUpLocation)
            addRideViewDelegate?.addRide(ride: ride) */
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
        if(segue.identifier == "addRideSegue")
        {
            if let addRideViewController = segue.destination as? AddRideViewController
            {
                addRideViewController.addRideViewDelegate = self
            }
        }
        else if(segue.identifier == "rideDetailSegue")
        {
            if let rideDetailViewController = segue.destination as? RideDetailViewController
            {
                rideDetailViewController.titleText = rides[currentRow].title
                rideDetailViewController.descriptionText = rides[currentRow].description
                rideDetailViewController.meetUpLocationText = rides[currentRow].meetUpLocation
                rideDetailViewController.dateText = rides[currentRow].date
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rides.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rideCell", for: indexPath)
     
        cell.textLabel?.text = rides[indexPath.row].title
        cell.detailTextLabel?.text = rides[indexPath.row].description
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        currentRow = indexPath.row
        performSegue(withIdentifier: "rideDetailSegue", sender: self)
        
        
        
        // use the historyDelegate to report back entry selected to the calculator scene
        //if let del = self.delegate
        //{
            //if let ll = self.tableViewData?[indexPath.section].entries[indexPath.row]
            //{
                //del.selectEntry(entry: ll)
            //}
        //}
        
        // this pops to the calculator
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            // Delete the row from the data source
            rides.remove(at: indexPath.row)
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

extension RideTableViewController: AddRideViewControllerDelegate
{
    func addRide(ride: Ride, distance: Double) -> Void
    {
        rides.append(ride)
        tableView.reloadData()
        
        //Adding ride to database
        addRideToDatabase(ride: ride, distance: distance)
    }
}

extension RideTableViewController {
    func addRideToDatabase(ride: Ride, distance: Double) {
        let ref = Database.database().reference()
        ref.child("rides/\(ride.title)").setValue([
            "Title": ride.title,
            "Description": ride.description,
            "MeetUpLocation": ride.meetUpLocation,
            "Distance": distance])
    }
}
