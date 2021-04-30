//
//  RouteViewController.swift
//  UberClone
//
//  Created by Özgün Yildiz on 28.04.21.
//

import UIKit
import MapKit

// when we start this VC, there are a couple question we have to think of:
// What kind of data do we want to populate it with? - Since it is a VC on which we will populate rideQuotes, we will need multiple things
// ONLY Ridequotes of course won't be enough, because in order to get a ridequote, we need 2 things: A pickup and a dropoff location. Since we have a locationService, with which we can seed data and get locations, we can use that

class RouteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
  
    @IBOutlet weak var routeLabelContainer: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var selectRideButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var pickupLbl: UILabel!
    
    @IBOutlet weak var dropoffLbl: UILabel!
    
//     we need a pickup and dropofflocation in order to generate a rideQuote
    var pickUpLocation: Location!
    var dropoffLocation: Location!
    var rideQuotes = [RideQuote]()
    var selectedIndex = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        // delegate + datasource
        tableView.dataSource = self
        tableView.delegate = self

        // Rounding all the corners
        routeLabelContainer.layer.cornerRadius = 10.0
        backButton.layer.cornerRadius = backButton.frame.size.width / 2
        selectRideButton.layer.cornerRadius = 10.0


//        // Populating properties for testing purposes
//        let locations = LocationService.shared.returnLocations()
//        // in order to calculate a rideQuote, we need a pickup and dropoff location
//        // we know there are multiple locations we can pick from, we just pick first and second
//        pickUpLocation = locations[0]
//        dropoffLocation = locations[1]
        
        pickupLbl.text = pickUpLocation?.title
        dropoffLbl.text = dropoffLocation?.title

        // the getQuotes method takes in a pickuplocation and a dropofflocation and return an array of rideQuotes
        rideQuotes = RideQuoteService.shared.getQuotes(pickupLocation: pickUpLocation!, dropoffLocation: dropoffLocation!)
        
        
        // Add annotations to mapView
        let pickupCoordinate = CLLocationCoordinate2D(latitude: pickUpLocation!.lat, longitude: pickUpLocation!.lng)
        let dropoffCoordinate = CLLocationCoordinate2D(latitude: dropoffLocation!.lat, longitude: dropoffLocation!.lng)
        let pickupAnnotation = LocationAnnotation(coordinate: pickupCoordinate, locationType: "pickup")
        let dropOffAnnotation = LocationAnnotation(coordinate: dropoffCoordinate, locationType: "dropoff")
        // if we leave it like that, mapView will illustrate them with a red pin, we want something different
        mapView.addAnnotations([pickupAnnotation, dropOffAnnotation])
        
        mapView.delegate = self
        
        displayRoute(sourceLocation: pickUpLocation!, destinationLocation: dropoffLocation!)
    }
    
    func displayRoute(sourceLocation: Location, destinationLocation: Location){
            let sourceCoordinate = CLLocationCoordinate2D(latitude: sourceLocation.lat, longitude: sourceLocation.lng)
            let destinationCoordinate =  CLLocationCoordinate2D(latitude: destinationLocation.lat, longitude: destinationLocation.lng)
            let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
            let destinationPlaceMark = MKPlacemark(coordinate: destinationCoordinate)
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: sourcePlacemark)
            directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate { (response, error) in
                if let error = error{
                    print("There's an error with calculating route \(error)")
                    return
                }
                
                if let response = response {
                    let route = response.routes[0]
                    self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                
                    let EDGE_INSET: CGFloat = 80.0
                    let boundingMapRect = route.polyline.boundingMapRect
                    self.mapView.setVisibleMapRect(boundingMapRect, edgePadding: UIEdgeInsets(top: EDGE_INSET, left: EDGE_INSET, bottom: EDGE_INSET, right: EDGE_INSET), animated: false)
                }
            }
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideQuotes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideQuoteCell") as! RideQuoteCell
        cell.update(rideQuote: rideQuotes[indexPath.row])
        cell.updateSelectedStatus(status: indexPath.row == selectedIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let selectedRideQuote = rideQuotes[indexPath.row]
        selectRideButton.setTitle("Select \(selectedRideQuote.name)", for: .normal)
        tableView.reloadData()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 5.0
        renderer.strokeColor = UIColor(red: 149.0 / 255.0, green: 67.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
        return renderer
    }
    
    
    
    
    // custom annotation View
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseIdentifier = "LocationAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView!.annotation = annotation
        }
        let locationAnnotation = annotation as! LocationAnnotation
        annotationView!.image = UIImage(named: "dot-\(locationAnnotation.locationType)")
        print(annotationView!.image)
        return annotationView
    }

}
