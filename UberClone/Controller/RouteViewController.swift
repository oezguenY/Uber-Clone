//
//  RouteViewController.swift
//  UberClone
//
//  Created by Özgün Yildiz on 28.04.21.
//

import UIKit

class RouteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    
    @IBOutlet weak var routeLabelContainer: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var selectRideButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var pickUpLocation: Location?
    var dropoffLocation: Location?
    var rideQuotes = [RideQuote]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Rounding all the corners
        routeLabelContainer.layer.cornerRadius = 10.0
        backButton.layer.cornerRadius = backButton.frame.size.width / 2
        selectRideButton.layer.cornerRadius = 10.0
        
        
        // Populating properties for testing purposes
        let locations = LocationService.shared.returnLocations()
        pickUpLocation = locations[0]
        dropoffLocation = locations[1]
        
        rideQuotes = RideQuoteService.shared.getQuotes(pickupLocation: pickUpLocation!, dropoffLocation: dropoffLocation!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideQuotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideQuoteCell") as! RideQuoteCell
        cell.update(rideQuote: rideQuotes[indexPath.row])
        return cell
    }
    
    
    
}
