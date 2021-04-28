//
//  LocationViewController.swift
//  UberClone
//
//  Created by Özgün Yildiz on 28.04.21.
//

import UIKit

class LocationViewController: UIViewController, UITableViewDataSource {
    
    var locations = [Location]()
    var pickupLocation: Location?
    var dropoffLocation: Location?
    @IBOutlet weak var dropoffTextfield: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locations = LocationService.shared.returnLocations()
        dropoffTextfield.becomeFirstResponder()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        let location = locations[indexPath.row]
        cell.update(location: location)
        return cell
    }
    
    
}
