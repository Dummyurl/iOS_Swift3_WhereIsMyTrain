//
//  MapViewVC.swift
//  WhereIsMyTrain
//
//  Created by etudiant-06 on 06/04/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewVC: UIViewController {
    
    // MARK: - CONSTANTS & VARIABLES
    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()
    var initialUserLocation : CLLocation?
    var stations: [Station]?
    
    // MARK: - VIEW'S FUNCS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        requestLocationAccess()
        //self.mapView.userTrackingMode = .followWithHeading
        addStationsInMap()
    }
    
}


//MARK: - USER LOCATION
extension MapViewVC: CLLocationManagerDelegate {
    
    //Asking the Authorization
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    // Initialization for the localization
    func initUSerLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationAccess()
        locationManager.startUpdatingLocation()
    }
    
    // Zooming on the user location
    func zoomOnTheUserLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // Update the localization
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location status updated")
        if let lastPosition = locations.last {
            zoomOnTheUserLocation(location: lastPosition)
            locationManager.stopUpdatingLocation()
        }
    }
}

// MARK: - Funcs using by the Map
extension MapViewVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKStationAnnotation {
            let stationView = mapView.dequeueReusableAnnotationView(withIdentifier: "stationPin") ?? MKAnnotationView()
            
            // Appearence of my Pin Annotation
            stationView.canShowCallout = true
            
            stationView.image = UIImage(named: "M")
            stationView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            
            //Adding my MKAnnotation to my MKAnnotationView
            stationView.annotation = annotation
            
            return stationView
        }
        else {
          return nil
        }
    }
    func addStationsInMap() {
        self.stations?.removeAll()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            stations = try context.fetch(Station.fetchRequest())
            
            for station in stations! {
                station.line?.forEach{ print("\($0 as! Line).id)") }
            }
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.stations?.forEach{addPinInMap($0)}
        } catch {
            print(error)
        }
    }
    func addPinInMap(_ station: Station) {
        let pin = MKStationAnnotation()
        
        pin.buildStationLocation(station)
        pin.title = station.name
        pin.pinColor = UIColor.brown
        self.mapView.addAnnotation(pin)
        
    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let location = userLocation.location {
            zoomOnTheUserLocation(location: location)
        }
    }
}
