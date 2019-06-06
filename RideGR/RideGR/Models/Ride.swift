//
//  Ride.swift
//  RideGR
//
//  Created by Joseph Stahle on 5/31/19.
//  Copyright © 2019 SWGVSUCIS657. All rights reserved.
//

import Foundation

class Ride
{
    var owner: String
    var title: String
    var description: String
    var meetUpLocation: String
    var date: String
    
    init(owner: String, title: String, description: String, meetUpLocation: String, date: String)
    {
        self.owner = owner
        self.title = title
        self.description = description
        self.meetUpLocation = meetUpLocation
        self.date = date
    }
}
