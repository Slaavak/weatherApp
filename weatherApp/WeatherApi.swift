//
//  WeatherApi.swift
//  weatherApp
//
//  Created by Slava Korolevich on 9/17/20.
//  Copyright © 2020 Slava Korolevich. All rights reserved.
//

import Foundation

//MARK: -  request

struct Weather: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

struct Main: Codable {
    var temp: Double?
    var feels_like: Double?
    var pressure: Int?
    var temp_min: Double?
    var temp_max: Double?
    var sea_level: Int?
    var grnd_level: Int?
    var temp_kf: Double?
    var humidity: Int?
}

struct Sys: Codable {
    var pod: String?
}

struct Clouds: Codable {
    var all: Int?
}

struct Wind: Codable {
    var speed: Double?
    var deg: Int?
}

struct List: Codable {
    var dt: Int?
    var main: Main?
    var weather: [Weather]?
    var clouds: Clouds?
    var wind: Wind?
    var visibility: Int
    var pop: Int
    var sys: Sys?
    var dt_txt: String?
}

struct City: Codable {
    var sunrise: Int?
    var sunset: Int?
    var id: Int?
    var country: String?
    var population: Int?
    var timezone: Int?
    var coord: Coord?
}

struct Coord: Codable {
    var lat: Double?
    var lon: Double?
}

struct ResultWeather: Codable {
    var message: Int?
    var cnt: Int?
    var cod: String?
    var list: [List]?
    var city: City?
}

class WeatherApi {
    
    static func getWeather(lat: Double, lon: Double, _ completion: @escaping (ResultWeather?) -> () ) {
        
        let url = URL(string:"https://api.openweathermap.org/data/2.5/onecall?lat=53&lon=27&exclude=minutely&units=metric&appid=ac49b7d9b8c5c5163e0bdd9888250841")
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if error == nil, let data = data {
                
                do {
                    let weather = try JSONDecoder().decode(ResultWeather.self, from: data)
                    completion(weather)
                } catch {
                    print(error)
                    completion(nil)
                }
                
            } else {
                completion(nil)
            }
            
        }
        dataTask.resume()
    }
    
}
