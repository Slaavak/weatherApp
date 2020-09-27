//
//  WeatherLoadManager.swift
//  weatherApp
//
//  Created by Slava Korolevich on 9/21/20.
//  Copyright © 2020 Slava Korolevich. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherLoadManagerDelegate: class {
    func weatherLoadManager(_ manager: WeatherLoadManager, didUpdateWeather: ResultWeather?, cityName: String?)
}

class WeatherLoadManager: UserLocationManagerDelegate {
    
    private struct DelegateWrapper {
        weak var delegate: WeatherLoadManagerDelegate?
    }
    
    
    static let instance = WeatherLoadManager()
    
    private(set) var weather: ResultWeather?
    private(set) var currentWeatherLocation: CLLocationCoordinate2D?
    var cityName: String?
    
    private var loadedFirstTime = false
    
    private var delegates: [DelegateWrapper] = []
    
    // MARK: - Interface
    
    func startWorking() {
        UserLocationManager.instance.delegate = self
        UserLocationManager.instance.requestLocation()
    }
    
    // MARK: - Delegates
    
    func addDelegate(_ delegate: WeatherLoadManagerDelegate) {
        delegates.append(.init(delegate: delegate))
    }
    
    func removeDelegate(_ delegate: WeatherLoadManagerDelegate) {
        delegates = delegates.filter({ $0.delegate != nil && $0.delegate !== delegate })
    }
    
    // MARK: - UserLocationManagerDelegate
    
    func userLocationManager(_ manager: UserLocationManager, didUpdateLocation location: CLLocationCoordinate2D) {
        if !loadedFirstTime {
            loadedFirstTime = true
            loadWeather(coordinate: location)
        }
    }
    
    // MARK: - Logic
    
    private func loadWeather(coordinate: CLLocationCoordinate2D) {
        WeatherApi.getWeather(lat: coordinate.latitude, lon: coordinate.longitude) { [weak self] weather in
            if let weather = weather {
                self?.weather = weather
                
                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
                    self?.cityName = (placemarks ?? []).compactMap({ $0.locality }).first!
                    self?.notifyDelegatesAboutNewData()
                })
            } else {
                self?.notifyDelegatesAboutNewData()
            }
        }
    }
    
    private func notifyDelegatesAboutNewData() {
        delegates = delegates.filter({ $0.delegate != nil })
        delegates.forEach({ $0.delegate?.weatherLoadManager(self, didUpdateWeather: weather, cityName: cityName) })    }
}

