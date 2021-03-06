//
//  LocationCell.swift
//  UberClone
//
//  Created by Özgün Yildiz on 21.04.21.
//

import UIKit
import MapKit

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var addressLine1Lbl: UILabel!

    @IBOutlet weak var addressLine2Lbl: UILabel!
 
    func update(location: Location) {
        addressLine1Lbl.text = location.title
        addressLine2Lbl.text = location.subtitle
    }
    
    func update(searchResult: MKLocalSearchCompletion) {
        addressLine1Lbl.text = searchResult.title
        addressLine2Lbl.text = searchResult.subtitle
    }
    
}
