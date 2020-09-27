//
//  ViewController.swift
//  weatherApp
//
//  Created by Slava Korolevich on 9/17/20.
//  Copyright © 2020 Slava Korolevich. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WeatherLoadManagerDelegate {
    
    enum WeatherType {
        case current
        case forecast
    }
    
    //MARK: - Properties
    
    var weatherType: WeatherType = .current
    var cityName: String?
    var degreeText: String?
    
    var lat: Double?
    var lon: Double?
    var weather: ResultWeather?
    
    let navigationTabHeight: CGFloat = 85
    var screenWidth:CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    
    var weatherIconImageView = UIImageView()
    
    var cityNameLabel = UILabel()
    var weatherLabel = UILabel()
    var humidityLabel = UILabel()
    var pressureLabel = UILabel()
    var windSpeedLabel = UILabel()
    
    var shareButton = UIButton(type: UIButton.ButtonType.system)
    
    var scrollView = UIScrollView()
    var tableView = UITableView()
    
    var footerDescriptionView = UIView()
    var headerDescriptionView = UIView()
    var descriptionView = UIView()
    let mainView = UIView()
    var humidityView = UIView()
    var pressureView = UIView()
    var windSpeedView = UIView()
    var feelsLikeView = UIView()
    var visibilityView = UIView()
    var weatherDescriptionView = UIView()
    
    var iconArray: [String] = []
    var sections: [[String]] = [[]]
    var daysArr: [String] = []
    private var icons: [URL: UIImage] = [:]
    
    
    private lazy var df: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        if let timezone = weather?.city?.timezone {
            df.timeZone = TimeZone.init(secondsFromGMT: timezone)
        }
        return df
    }()
    
    private lazy var sectionHeaderDf: DateFormatter = {
        let sectionHeaderDF = DateFormatter()
        sectionHeaderDF.dateFormat = "EEEE"
        if let timezone = weather?.city?.timezone {
            sectionHeaderDF.timeZone = TimeZone.init(secondsFromGMT: timezone)
        }
        return sectionHeaderDF
    }()
    
    
    //MARK: - Life Cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        screenWidth = self.view.bounds.width
        screenHeight = self.view.bounds.height
        
        if weatherType == .current {
            configUIForCurrentWeather()
        } else {
            configUIForForecastWeather()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherLoadManager.instance.addDelegate(self)
        
        tableView.register(ForecastWeatherCell.self, forCellReuseIdentifier: "Cell")
        
        if weatherType == .current {
            title = "today"
        } else {
            title = "forecast"
            self.weather = WeatherLoadManager.instance.weather
        }
    }
    
    
    //MARK:- tableView delegate && dataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ForecastWeatherCell
        cell.selectionStyle = .none
        
        if let item = weather?.list?[indexPath.row] {
            if let temp = item.main?.temp {
                cell.degreeLabel.text = "\(Int(temp))\u{00B0}"
            }
            if let description = item.weather?.first?.description {
                cell.descriptionLabel.text = description
            }
            if let dt = item.dt {
                let time = Date.init(timeIntervalSince1970: TimeInterval(dt))
                let timeString: String = df.string(from: time)
                cell.timeLabel.text = timeString
            }
        }
        
        cell.iconImageView.image = nil
        if let iconName = weather?.list?[indexPath.row].weather?.first?.icon {
            if let url = URL(string: "https://openweathermap.org/img/w/\(iconName).png") {
                
                if let image = icons[url] {
                    cell.iconImageView.image = image
                }
                DispatchQueue.global().async { [weak self, weak cell] in
                    if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.icons[url] = image
                            if let self = self, let cell = cell, let index = self.tableView.indexPath(for: cell)?.row, index == indexPath.row {
                                cell.iconImageView.image = image
                            }
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionHeaderString: String = ""
        if let date = weather?.list?[0].dt {
            let dateString: String = sectionHeaderDf.string(from: Date.init(timeIntervalSince1970: TimeInterval(date + (section * 86400))))
            sectionHeaderString = dateString
        }
        return sectionHeaderString
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        sections = Dictionary(grouping: daysArr, by: { $0}).map { $0.value} // TODO
        return sections[section].count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let list = weather?.list! {
            for i in list {
                let time = Date.init(timeIntervalSince1970: TimeInterval(i.dt!))
                let string = sectionHeaderDf.string(from: time)
                daysArr.append(string)
            }
            
        }
        sections = Dictionary(grouping: daysArr, by: { $0}).map { $0.value}
        print(sections)
        
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    //MARK:- configure UI
    
    func configUIForCurrentWeather() {
        
        mainView.frame = self.view.frame
        self.view.addSubview(mainView)
        mainView.backgroundColor = .white
        
        mainView.addSubview(cityNameLabel)
        
        cityNameLabel.textAlignment = .center
        cityNameLabel.font = .systemFont(ofSize: 18)
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(weatherIconImageView)
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(weatherLabel)
        weatherLabel.textAlignment = .center
        weatherLabel.font = .systemFont(ofSize: 30)
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(descriptionView)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.addSubview(footerDescriptionView)
        descriptionView.addSubview(headerDescriptionView)
        
        descriptionView.addSubview(humidityView)
        descriptionView.addSubview(pressureView)
        descriptionView.addSubview(windSpeedView)
        descriptionView.addSubview(feelsLikeView)
        descriptionView.addSubview(visibilityView)
        descriptionView.addSubview(weatherDescriptionView)
        
        mainView.addSubview(shareButton)
        shareButton.setTitle("Share", for: UIControl.State.normal)
        shareButton.setTitleColor(UIColor.orange, for: UIControl.State.normal)
        shareButton.sizeToFit()
        shareButton.titleLabel?.font = .systemFont(ofSize: 26)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherIconImageView.topAnchor.constraint(equalTo: mainView.topAnchor ,constant: navigationTabHeight + 32),
            weatherIconImageView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 96),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 96),
            
            cityNameLabel.topAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor ,constant: 16),
            cityNameLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            cityNameLabel.heightAnchor.constraint(equalToConstant: 20),
            cityNameLabel.widthAnchor.constraint(equalToConstant: 200),
            
            weatherLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor ,constant: 16),
            weatherLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            weatherLabel.heightAnchor.constraint(equalToConstant: 40),
            weatherLabel.widthAnchor.constraint(equalToConstant: 300),
            
            descriptionView.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 16),
            descriptionView.widthAnchor.constraint(equalToConstant: mainView.bounds.width),
            descriptionView.heightAnchor.constraint(equalToConstant: 200),
        
            shareButton.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 48),
            shareButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 100),
            shareButton.heightAnchor.constraint(equalToConstant: 20),
            
        ])
        headerDescriptionView.frame = CGRect(x: view.bounds.width * 0.5 / 2, y: 0, width: view.bounds.width * 0.5, height: 1)
        footerDescriptionView.frame = CGRect(x: view.bounds.width * 0.5 / 2, y: 192 , width: view.bounds.width * 0.5, height: 1)
        footerDescriptionView.backgroundColor = .gray
        headerDescriptionView.backgroundColor = .gray
    }
    
    func configUIForForecastWeather() {
        self.view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    //MARK: - Update Data
    
    private func updateData(weather: ResultWeather, city: String) {
        
        if let icon = weather.list?.first?.weather?.first?.icon {
            if let url = URL(string: "https://openweathermap.org/img/w/\(icon).png") {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url)
                    
                    DispatchQueue.main.async {
                        self.weatherIconImageView.image = UIImage(data: data!)
                    }
                }
            }
        }
        
        if let country = weather.city?.country {
            cityNameLabel.text = "\(city) | \(country)"
            if let temp = weather.list?.first?.main?.temp, let description = weather.list?.first?.weather?.first?.description {
                weatherLabel.text = "\(Int(temp)) | \(description)"
            }
        }
        
        for i in 0...(weather.list?.count)!-1 {
            iconArray.append("\((weather.list?[i].weather?.first?.icon)!)")
            
            if let humidity = weather.list?.first?.main?.humidity {
                humidityView = TodayWeatherCell(frame: CGRect(x: 0, y: 32 * 0, width: screenWidth, height: 31), name: "Humidity", value: "\(humidity)")
            }
            if let pressure = weather.list?.first?.main?.pressure {
                pressureView = TodayWeatherCell(frame: CGRect(x: 0, y: 32 * 1, width: screenWidth, height: 31), name: "Pressure", value: "\(pressure)")
            }
            if let windSpeed = weather.list?.first?.wind?.speed {
                windSpeedView = TodayWeatherCell(frame: CGRect(x: 0, y: 32 * 2, width: screenWidth, height: 31), name: "Wind speed", value: "\((windSpeed * 10).rounded() / 10) m/s")
            }
            if let feelsLike = weather.list?.first?.main?.feels_like {
                feelsLikeView = TodayWeatherCell(frame: CGRect(x: 0, y: 32 * 3, width: screenWidth, height: 31), name: "Feels Like", value: "\(Int(feelsLike))\u{00B0}C")
            }
            if let visibility = weather.list?.first?.visibility {
                visibilityView = TodayWeatherCell(frame: CGRect(x: 0, y: 32 * 4, width: screenWidth, height: 31), name: "Visibility", value: "\(visibility/1000)km")
            }
            if let weatherDescription = weather.list?.first?.weather?.first?.description {
                weatherDescriptionView = TodayWeatherCell(frame: CGRect(x: 0, y: 32 * 5, width: screenWidth, height: 31), name: "Description", value: "\(weatherDescription)")
            }
            
        }
    }
    
    //MARK:- WatherLoadManagerDelegate
    
    func weatherLoadManager(_ manager: WeatherLoadManager, didUpdateWeather weather: ResultWeather?, cityName: String?) {
        DispatchQueue.main.async {
            self.cityName = cityName
            self.weather = weather
            
            self.updateData(weather: weather!, city: cityName!)
            
            if let timezone = weather?.city?.timezone {
                self.df.timeZone = TimeZone.init(secondsFromGMT: timezone)
                self.sectionHeaderDf.timeZone = TimeZone.init(secondsFromGMT: timezone)
            }
        }
    }
}
