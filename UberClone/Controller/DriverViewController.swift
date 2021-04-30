//
//  DriverViewController.swift
//  UberClone
//
//  Created by Özgün Yildiz on 30.04.21.
//

import Foundation
import UIKit
import MapKit

class DriverViewController: UIViewController, MKMapViewDelegate {

    var pickupLocation: Location!
    var dropoffLocation: Location!

    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var driverNameLbl: UILabel!
    @IBOutlet weak var carLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        driverImageView.layer.cornerRadius = driverImageView.frame.size.width / 2.0
        licenseLabel.layer.cornerRadius = 15.0
        licenseLabel.layer.borderColor = UIColor.gray.cgColor
        licenseLabel.layer.borderWidth = 1.0

        backButton.layer.cornerRadius = backButton.frame.size.width / 2.0

        mapView.delegate = self

        let (driver, eta) = DriverService.shared.getDriver(pickupLocation: pickupLocation)
        
        let locations = LocationService.shared.returnLocations()
        pickupLocation = locations[0]
        dropoffLocation = locations[1]

        etaLabel.text = "ARRIVES IN \(eta) MIN"
        driverNameLbl.text = driver.name
        carLbl.text = driver.car
        let ratingString = String(format: "%.1f", driver.rating)
        ratingImageView.image = UIImage(named: "rating-\(ratingString)")
        ratingLbl.text = ratingString
        carImageView.image = UIImage(named: driver.car)
        driverImageView.image = UIImage(named: driver.thumbnail)
        licenseLabel.text = driver.licenseNumber


        // Add annotations
        let driverAnnotation = VehicleAnnotation(coordinate: driver.coordinate)
        let pickupCoordinate = CLLocationCoordinate2D(latitude: pickupLocation!.lat, longitude: pickupLocation!.lng)
        let dropoffCoordinate = CLLocationCoordinate2D(latitude: dropoffLocation!.lat, longitude: dropoffLocation!.lng)
        let pickupAnnotation = LocationAnnotation(coordinate: pickupCoordinate, locationType: "pickup")
        let dropoffAnnotation = LocationAnnotation(coordinate: dropoffCoordinate, locationType: "dropoff")
        let annotations: [MKAnnotation] = [driverAnnotation, pickupAnnotation, dropoffAnnotation]
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: false)


        let driverLocation = Location(title: driver.name, subtitle: driver.licenseNumber, lat: driver.coordinate.latitude, lng: driver.coordinate.longitude)
        displayRoute(sourceLocation: driverLocation, destinationLocation: pickupLocation)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }

        let reuseIdentifier = annotation is VehicleAnnotation ? "VehicleAnnotation" : "LocationAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else{
            annotationView?.annotation = annotation
        }

        if annotation is VehicleAnnotation{
            annotationView?.image = UIImage(named: "car")
        } else if let locationAnnotation = annotation as? LocationAnnotation{
            annotationView?.image = UIImage(named: "dot-\(locationAnnotation.locationType)")
        }

        return annotationView

    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 5.0
        renderer.strokeColor = UIColor(red: 247.0/255.0, green: 66.0/255.0, blue: 190.0/255.0, alpha: 1)
        return renderer
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

            }

        }
    }

    @IBAction func backButtonDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func editRideButtonDidTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    
    
}
