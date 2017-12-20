//
//  Marker.swift
//  Wifi Tracker
//
//  Created by C on 11/11/2017.
//  Copyright © 2017 Tizeti Networks Limited. All rights reserved.
//

import Foundation

struct Marker {
    let address : String
    let lat : String
    let lng : String

}

extension Marker: JSONDecodable{
    init(_ decoder: JSONDecoder) throws {
        self.address = try decoder.value(forKey : "address")
        self.lat = try decoder.value(forKey : "lat")
        self.lng = try decoder.value(forKey : "lng")
    }
}




