//
//  DriverService.swift
//  UberClone
//
//  Created by Özgün Yildiz on 30.04.21.
//

import Foundation

class DriverService {
    static let shared = DriverService()
    
    private init() {}
    
    
    func getDriver(pickupLocation: Location) -> (Driver, Int) {
        let driver = Driver(name: "Alicia Castillo", thumbnail: "alicia", licenseNumber: "7WB312S", rating: 5.0, car: "Hyundai Sonata")
        return (driver, 10)
    }
    
}
