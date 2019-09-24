//
//  InterfaceController.swift
//  Citybikes WatchKit Extension
//
//  Created by Wojtek Siudzinski on 24/09/2019.
//  Copyright © 2019 Gaia Green Tech. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var mapView: WKInterfaceMap!
    var locationManager: CLLocationManager?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        setupLocation()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}

extension InterfaceController: CLLocationManagerDelegate {
    func setupLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            mapView.setRegion(MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500))
        }
    }
}
