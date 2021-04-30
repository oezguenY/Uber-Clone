//
//  Driver.swift
//  UberClone
//
//  Created by Özgün Yildiz on 30.04.21.
//

import Foundation

class Driver {
    
    let name: String
    let thumbnail: String
    let licenseNumber: String
    let rating: Float
    let car: String
    
    init(name: String, thumbnail: String, licenseNumber: String, rating: Float, car: String) {
        self.name = name
        self.thumbnail = thumbnail
        self.licenseNumber = licenseNumber
        self.rating = rating
        self.car = car
    }
    
}
