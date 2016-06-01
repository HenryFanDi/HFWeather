//
//  MainViewController.swift
//  Weather
//
//  Created by HenryFan on 19/5/2016.
//  Copyright © 2016 HenryFanDi. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
  
  private let locationManager = CLLocationManager()
  
  @IBOutlet weak var countryLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getUserLocation()
    fetchWeatherAPI()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: Private
  
  private func getUserLocation() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  private func fetchWeatherAPI() {
    if let userLocation = locationManager.location as CLLocation? {
      let parameters = [
        "latitude": String(format: "%f", userLocation.coordinate.latitude),
        "longitude": String(format: "%f", userLocation.coordinate.longitude)
      ]
      unowned let unownedSelf = self
      APIHelper.sharedInstance.fetchAPIDataWithAPIType(.WeatherAPI, parameters: parameters) { (result, statusCode, error) in
        let weather = result as? Dictionary <String, AnyObject>
        if weather != nil {
          unownedSelf.countryLabel.text = weather!["sys"]!["country"] as? String
          unownedSelf.cityLabel.text = weather!["name"] as? String
          unownedSelf.temperatureLabel.text = String(format: "%.0f", (weather!["main"]!["temp"]!)!.floatValue / 10.0)
          
          var statusStr = ""
          for dict in (weather!["weather"] as! [Dictionary <String, AnyObject>]) {
            let model = WeatherModel.init(weatherDescription: dict["description"] as? String,
                                          icon: dict["icon"] as? String,
                                          weatherID: dict["id"] as? String,
                                          main: dict["main"] as? String)
            let str = model?.weatherDescription?.capitalizedStringWithLocale(NSLocale.currentLocale())
            statusStr = statusStr.stringByAppendingString(String(format: "%@ ", str!))
          }
          unownedSelf.statusLabel.text = statusStr
        }
      }
    }
  }
  
}
