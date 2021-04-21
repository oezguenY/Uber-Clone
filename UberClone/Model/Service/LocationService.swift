//
//  LocationService.swift
//  UberClone
//
//  Created by Özgün Yildiz on 20.04.21.
//

import Foundation

class LocationService {
    static let shared = LocationService()
    
    private var recentLocations = [Location]()
    
    private init() {
       let locationsUrl = Bundle.main.url(forResource: "locations", withExtension: "json")!
        // we are decoding the json into data (represents zeros and ones)
        let data = try! Data(contentsOf: locationsUrl)
        // now, we have to decode it into our native swift object
        let decoder = JSONDecoder()
        // the first argument of the decode method specifies what we want the data to decode in (in this case an array of Location objects) and the second argument specifies which data we are using for that
        recentLocations = try! decoder.decode([Location].self, from: data)
    }
    
    // since our recentLocations variable is private, we need a method for other objects to be able to access it
    
    func getRecentLocations() -> [Location] {
        return recentLocations
    }
    
}
