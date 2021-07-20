//
//  RouteController.swift
//  TravelSites
//
//  Created by eyal avisar on 20/07/2021.
//  Copyright © 2021 eyal avisar. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class RouteController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var destinationCoordinate: CLLocationCoordinate2D? = nil

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0

        return renderer
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            renderRouteFromSource(sourceLocation: location.coordinate)
        }
    }
    
    func renderRouteFromSource(sourceLocation: CLLocationCoordinate2D) {
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate!, addressDictionary: nil)

        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        // 5.
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "current location"

        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }


        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "destination"

        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }

        // 6.
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )

        // 7.
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking

        // Calculate the direction
        let directions = MKDirections(request: directionRequest)

        // 8.
        directions.calculate {
            (response, error) -> Void in

            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }

                return
            }

            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)

            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }

    }
}
