//
//  VehicleAnnotation.swift
//  UberClone
//
//  Created by Özgün Yildiz on 21.04.21.
//

import MapKit

class VehicleAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
