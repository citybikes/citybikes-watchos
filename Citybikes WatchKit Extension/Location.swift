//
//  Location.swift
//  Citybikes WatchKit Extension
//
//  Created by Wojtek Siudzinski on 30/09/2019.
//  Copyright © 2019 Gaia Green Tech. All rights reserved.
//

import Foundation
import WatchKit
import CoreLocation

protocol LocatorProtocol: AnyObject {
    func locationUpdated(_ locator: Locator)
    func locatorError(error: Error)
}

enum LocatorState {
    case waiting
    case updating
}

class Locator: NSObject, CLLocationManagerDelegate {
    var manager: CLLocationManager!
    weak var delegate: LocatorProtocol?
    var state: LocatorState! = .waiting

    override init() {
        super.init()

        // Setup CLLocationManager
        manager = CLLocationManager()
        manager.activityType = .other
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = true
        manager.requestWhenInUseAuthorization()

        doUpdate()
    }

    func doUpdate() {
        print("doUpdate")
        if state == .updating {
            return
        }
        if CLLocationManager.locationServicesEnabled() {
            self.state = .updating
            manager.startUpdatingLocation()
        } else {
            // TODO: Notify user about enabling location services
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        delegate?.locatorError(error: error)
        state = .waiting
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        manager.stopUpdatingLocation()
        state = .waiting

        if let location = locations.last {
            let extensionDelegate = WKExtension.shared().delegate as? ExtensionDelegate
            extensionDelegate?.model?.fetchStations(location: location.coordinate) { error in
                if let error = error {
                    self.delegate?.locatorError(error: error)
                } else {
                    self.delegate?.locationUpdated(self)
                }

            }
        }
    }
}
