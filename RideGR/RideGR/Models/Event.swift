//
//  Event.swift
//  RideGR
//
//  Created by Joseph Stahle on 6/1/19.
//  Copyright © 2019 SWGVSUCIS657. All rights reserved.
//

import Foundation

class Event
{
    var title: String
    var description: String
    var location: String
    
    init(title: String, description: String, location: String)
    {
        self.title = title
        self.description = description
        self.location = location
    }
}
