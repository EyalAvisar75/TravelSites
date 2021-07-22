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
    
    //MARK:- Properties
    var destinationCoordinate: CLLocationCoordinate2D? = nil
    let locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    var overlay: MKOverlay?
    var annotations = [MKAnnotation]()
    var transportationPad = [UIButton]()
    
    //MARK:- IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK:- Class methods
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var frame = CGRect(x: 10, y: 0.9 * view.bounds.height, width: view.bounds.width / 5, height: view.bounds.height / 10)
        let pedestrianButton = UIButton(frame: frame)
        pedestrianButton.backgroundColor = .red
        pedestrianButton.setTitle("Pedestrian", for: .normal)
        pedestrianButton.imageView?.contentMode = .scaleToFill
        pedestrianButton.setImage(UIImage(named: "pedestrian"), for: .normal)

        view.addSubview(pedestrianButton)
        transportationPad.append(pedestrianButton)
        
        frame.origin.x = 0.25 * view.bounds.width + 10
        let carButton = UIButton(frame: frame)
        carButton.backgroundColor = .red
        carButton.setTitle("Car", for: .normal)
        carButton.imageView?.contentMode = .scaleToFill
        carButton.setImage(UIImage(named: "car"), for: .normal)
        view.addSubview(carButton)
        transportationPad.append(carButton)
        
        frame.origin.x = 0.5 * view.bounds.width + 10
        let publicButton = UIButton(frame: frame)
        publicButton.backgroundColor = .red
        publicButton.setTitle("Public", for: .normal)
        publicButton.imageView?.contentMode = .scaleToFill
        publicButton.setImage(UIImage(named: "bus"), for: .normal)
        view.addSubview(publicButton)
        transportationPad.append(publicButton)
        
        frame.origin.x = 0.75 * view.bounds.width + 10
        let flightButton = UIButton(frame: frame)
        flightButton.backgroundColor = .red
        flightButton.setTitle("Flight", for: .normal)
        flightButton.imageView?.contentMode = .scaleToFill
        flightButton.setImage(UIImage(named: "heli"), for: .normal)
        view.addSubview(flightButton)
        transportationPad.append(flightButton)

        for button in transportationPad {
            button.addTarget(self, action: #selector(transportationButtonPressed), for: .touchUpInside)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func transportationButtonPressed(button: UIButton) {
        mapView.removeOverlay(overlay!)
        
        while !annotations.isEmpty {
            let annotation = annotations.popLast()!
            mapView.removeAnnotation(annotation)
        }

        switch button.title(for: .normal)! {
        case "Pedestrian":
            renderRouteFromSource(sourceLocation: currentLocation, transportation: .walking)
        case "Car":
            renderRouteFromSource(sourceLocation: currentLocation, transportation: .automobile)
        case "Public":
            renderRouteFromSource(sourceLocation: currentLocation, transportation: .transit)
            print("This type is only supported for estimating time of arrival.")
        case "Flight":
            renderRouteFromSource(sourceLocation: currentLocation, transportation: .any)
        default:
            fatalError("Add a suitable case")
        }
    }
    
    //MARK:- LocationManager methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            manager.stopUpdatingLocation()
            currentLocation = location.coordinate
            
            renderRouteFromSource(sourceLocation: location.coordinate, transportation: .automobile )
        }
    }
    
    //MARK:- Map methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let view = MyAnnotationView()
    
        print("read", annotation.title!!)
        if annotation.title!! == "destination" {
            view.isBlue = true
        }
        
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let overlay = overlay as? MKPolyline {
                /// define a list of colors you want in your gradient
                let gradientColors = [UIColor.green, UIColor.blue]

                /// Initialise a GradientPathRenderer with the colors
                let polylineRenderer = GradientPathRenderer(polyline: overlay, colors: gradientColors)

                /// set a linewidth
                polylineRenderer.lineWidth = 7
                return polylineRenderer
        }
        
        return MKOverlayRenderer()
    }
    
    func renderRouteFromSource(sourceLocation: CLLocationCoordinate2D, transportation: MKDirectionsTransportType) {
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate!, addressDictionary: nil)

        addAnottationsForPlacemark(source: sourcePlacemark, destination: destinationPlacemark)
        
        addRouteForPlacemarks(source: sourcePlacemark, destination: destinationPlacemark, transportation: transportation )
        
    }
    
    func addAnottationsForPlacemark(source: MKPlacemark, destination: MKPlacemark) {

        // 5.
        let sourceAnnotation = MKPointAnnotation()
//        let sourceAnnotation = MyAnnotation()
        annotations.append(sourceAnnotation)
        sourceAnnotation.title = "current location"
//        sourceAnnotation.annotationName = "source"

        if let location = source.location {
            sourceAnnotation.coordinate = location.coordinate
        }


//        let destinationAnnotation = MyAnnotation()
        let destinationAnnotation = MKPointAnnotation()
        annotations.append(destinationAnnotation)
        destinationAnnotation.title = "destination"
        

        if let location = destination.location {
            destinationAnnotation.coordinate = location.coordinate
        }

        // 6.
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
    }
    
    func addRouteForPlacemarks(source: MKPlacemark, destination: MKPlacemark, transportation: MKDirectionsTransportType) {
        
        let sourceMapItem = MKMapItem(placemark: source)
        let destinationMapItem = MKMapItem(placemark: destination)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = transportation

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
            
            self.overlay = route.polyline
            self.mapView.addOverlay(self.overlay!, level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            
            
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
}
