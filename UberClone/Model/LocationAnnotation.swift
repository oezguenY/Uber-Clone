//
//  LocationAnnotation.swift
//  UberClone
//
//  Created by Özgün Yildiz on 29.04.21.
//

import Foundation
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let locationType: String
    
    init(coordinate: CLLocationCoordinate2D, locationType: String) {
        self.coordinate = coordinate
        self.locationType = locationType
    }
}
