//
//  Markers.swift
//  Wifi Tracker
//
//  Created by C on 10/11/2017.
//  Copyright © 2017 Tizeti Networks Limited. All rights reserved.
//

import Foundation



struct Markers
{
    
    let name: String
    let address: String
    let lat: String?
     let lng: String?
     let type: String?
     let devicetype: String?
    let modelno: String?
    let mstatus:String?
 
}

extension Markers: JSONDecodable
{
    init(_ decoder: JSONDecoder) throws
    {
        self.name = try decoder.value(forKey: "name")
        self.address = try decoder.value(forKey: "address")
        self.lat = try decoder.value(forKey: "lat")
        self.lon = try decoder.value(forKey: "lon")
        

    }
}
