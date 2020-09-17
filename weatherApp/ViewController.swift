//
//  ViewController.swift
//  weatherApp
//
//  Created by Slava Korolevich on 9/17/20.
//  Copyright © 2020 Slava Korolevich. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    //MARK: - properties

    var lat: Double?
    var lon: Double?
    var locationManager = CLLocationManager()
    var weather: ResultWeather?
    
    var cityText: String?


    override func viewDidLoad() {
        super.viewDidLoad()

 self.startGettingLocation()
    }

    private func runUpdate() {
        if let lat = lat, let lon = lon {
            WeatherApi.getWeather(lat: lat, lon: lon) { [weak self] weather in
                if let weather = weather {
                    self?.weather = weather
                    
                    let location = CLLocation(latitude: lat, longitude:  lon)
                    let geoCoder = CLGeocoder()
                    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
                        self?.cityText = (placemarks ?? []).compactMap({ $0.locality }).first
                        DispatchQueue.main.async {
                            self?.updateData()
                        }
                    })
                }
            }
        }
    }
    
    private func updateData() {
    }

   //MARK: - Get location
    
    func startGettingLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let shouldUpdate = (lat == nil) || (lon == nil)
        lat = locValue.latitude
        lon = locValue.longitude
        locationManager.stopUpdatingLocation()
        
        if shouldUpdate {
            runUpdate()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


