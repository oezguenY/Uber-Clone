//
//  HomeViewController.swift
//  UberClone
//
//  Created by Özgün Yildiz on 21.04.21.
//

import UIKit
import CoreLocation
import MapKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    var locations = [Location]()
    var locationManager: CLLocationManager!
    var currentUserLocation: Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let recentLocations = LocationService.shared.returnLocations()
        
        locations = [recentLocations[0], recentLocations[1]]
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        
        // Add shadow to searchButton
        searchButton.layer.cornerRadius = 10.0
        searchButton.layer.shadowRadius = 1.0
        searchButton.layer.shadowColor = UIColor.black.cgColor
        searchButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        searchButton.layer.shadowOpacity = 0.5
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let firstLocation = locations.first!
        // we are getting the location of the user here
        currentUserLocation = Location(title: "Current Location", subtitle: "", lat: firstLocation.coordinate.latitude, lng: firstLocation.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationCell {
            cell.update(location: locations[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // zoom in to the user location
        let distance = 200.0
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
        
        let lat = userLocation.coordinate.latitude
        let lng = userLocation.coordinate.longitude
        let offset = 0.00075
        let coord1 = CLLocationCoordinate2D(latitude: lat - offset, longitude: lng - offset)
        let coord2 = CLLocationCoordinate2D(latitude: lat, longitude: lng + offset)
        let coord3 = CLLocationCoordinate2D(latitude: lat, longitude: lng - offset)
        
        // create 3 vehicle annotations and add them to the mapView
        // we are seeding the mapView for testing purposes
        mapView.addAnnotations([
            VehicleAnnotation(coordinate: coord1),
            VehicleAnnotation(coordinate: coord2),
            VehicleAnnotation(coordinate: coord3)
        ])
       
    }
    
    // Creating custom car annoatations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // one annotation depicts us (with our location), so if
        // the annotation is our user Location, don't do anything
        
        if annotation is MKUserLocation {
            return nil
        }
        
        // Create custom annotation view with vehicle image
        // we have to give the annotationView a reuseIdentifier, as it is expected by the dequeueReusableAnnotationView
        let reuseIdentifier = "VehicleAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "VehicleAnnotation")
        // if we don't get back an annotationView...
        if annotationView == nil {
            // ...we create it ourselves
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            // if annotationView is not nil, assign the annotation that was passed into the method to annotationView
            annotationView?.annotation = annotation
        }
        // then pass the car image that we have in our assets to annotationView
        annotationView?.image = UIImage(named: "car")
        // rotating annotationView by transforming the object
        annotationView?.transform = CGAffineTransform(rotationAngle:
        // creating random number from 0-360 with arc4random_uniform
        // NOTE: the rotationAngle parameter only takes in radients. In order to transform
        // the radients to degrees, we conduct following math operation
        // As a result, the vehicle annotations will be randomly rotated
        CGFloat(arc4random_uniform(360) * 180) / CGFloat.pi)
        
        return annotationView
    }
   
    
    
    
}
