//
//  MapScreen.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 4/23/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapScreenController: UIViewController {

    let locationManager = CLLocationManager()
    let regionInMeters: Double = 0.01
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationService()
        // Do any additional setup after loading the view.
    }
    
    func setupLocationManger(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break

        }
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, span: MKCoordinateSpan.init(latitudeDelta: regionInMeters, longitudeDelta: regionInMeters) )
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationService(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManger()
            checkLocationAuthorization()
        }
        else
        {
            disabledLocationAllert()
        }
    }
    
    func disabledLocationAllert(){
        let alert = UIAlertController(title: "Error", message: "Enable location services", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension MapScreenController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, span: MKCoordinateSpan(latitudeDelta: regionInMeters, longitudeDelta: regionInMeters))
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

