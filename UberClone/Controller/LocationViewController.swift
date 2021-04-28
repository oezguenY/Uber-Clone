//
//  LocationViewController.swift
//  UberClone
//
//  Created by Özgün Yildiz on 28.04.21.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate, MKLocalSearchCompleterDelegate {
    
    var locations = [Location]()
    var pickupLocation: Location?
    var dropoffLocation: Location?
    // we need this, because we want the text the user types into the dropoffTextField to autocomplete with the corresponding location
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    @IBOutlet weak var dropoffTextfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locations = LocationService.shared.returnLocations()
        // when we open the VC, the textfield is being automatically selected
        // (becomesFirstResponder) and the keyboard is being pushed up
        dropoffTextfield.becomeFirstResponder()
        dropoffTextfield.delegate = self
        // the viewController is the delegate of the searchCompleter
        searchCompleter.delegate = self
    }
    
    // delegate method; If the textfield was typed in (dropOffTextfield), we are notifying the LocationViewController (which is the delegate) that changes happened (with every single change in the textField (deletions, modifications, additions)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // we are replacing what was previously in the textField with the range that the user wants to update and the update that the user wants to make. The result of this is being stored in latestString
        let latestString = (textField.text as! NSString).replacingCharacters(in: range, with: string)
        print("latest String \(latestString)")
        // queryFragment is the search string for which we want the completion to happen. Keep in mind that this method (shouldChangeCharactersIn) fires every time the user modifies the textField, so when the user types b, the character (which is stored in latestString, is being passed to the searchCompleter, which will try to find all addresses with the letter b. Since we don't want this method to fire off with every single modification, we put an if statement
        if latestString.count > 3 {
            // passing the searchCompleter a string to search with
            searchCompleter.queryFragment = latestString
        }
        
        // the results are communicated to us with the delegation design pattern. Which is why we have to implement a delegate method and set the ViewController as the delegate of the searchCompleter
        
        return true
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
    
    // when this method is invoked, the searchCompleter is finished with its work and found results for us based on the query fragment that we set
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        // reload our tableView
        tableView.reloadData()
    }
    
}
