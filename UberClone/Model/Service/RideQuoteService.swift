//
//  RideQuoteService.swift
//  UberClone
//
//  Created by Özgün Yildiz on 21.04.21.
//

import Foundation
import CoreLocation

// we want the RideQuoteService to give us back a list of quotes for a given pickup and drop off location
class RideQuoteService {
    static let shared = RideQuoteService()
    
    private init() {
    }
    // depending on where we pick up the customer and drop him off, we calculate a corresponding RideQuote
    // in order to get the distance between the pickUpLocation and the dropOffLocation, we need CoreLocation
    func getQuotes(pickupLocation: Location, dropoffLocation: Location) -> [RideQuote] {
        // for each the pickupLocation, as well as the dropoffLocation, we need both longitude and latitude
        let location1 = CLLocation(latitude: pickupLocation.lat, longitude: pickupLocation.lng)
        let location2 = CLLocation(latitude: dropoffLocation.lat, longitude: dropoffLocation.lng)
        // the CLLocation Object has a method that calculates the distance between two locations
        // the result will be in meters
        let distance = location1.distance(from: location2)
        let minimumAmount = 3.0
        
        // seeding the data
        return [
            RideQuote(thumbnail: "ride-shared", name: "Shared", capacity: "1-2", price: minimumAmount + distance * 0.000005, time: Date()),
            RideQuote(thumbnail: "ride-compact", name: "Compact", capacity: "4", price: minimumAmount + distance * 0.000007, time: Date()),
            RideQuote(thumbnail: "ride-large", name: "Large", capacity: "6", price: minimumAmount + distance * 0.0000040, time: Date())
        ]
    }
}
