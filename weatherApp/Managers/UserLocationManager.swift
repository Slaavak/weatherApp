//
//  UserLocationManager.swift
//  weatherApp
//
//  Created by Slava Korolevich on 9/26/20.
//  Copyright © 2020 Slava Korolevich. All rights reserved.
//

import Foundation
import CoreLocation

protocol UserLocationManagerDelegate: class {
    func userLocationManager(_ manager: UserLocationManager, didUpdateLocation location: CLLocationCoordinate2D)
}

class UserLocationManager: NSObject, CLLocationManagerDelegate {
    
    
    private(set) var currentUserLocation: CLLocationCoordinate2D?
    
    
    private let locationManager: CLLocationManager
    
    weak var delegate: UserLocationManagerDelegate?
    
    static let instance = UserLocationManager()
    
    private var requestedLocation = false
    
    // MARK: Init
    
    override private init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    // MARK: - Interface
    
    func requestLocation() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            requestedLocation = true
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentUserLocation = locations.first?.coordinate
        if let coordinate = self.currentUserLocation {
            self.delegate?.userLocationManager(self, didUpdateLocation: coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedWhenInUse || status == .authorizedAlways) && requestedLocation {
            manager.requestLocation()
            requestedLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}



