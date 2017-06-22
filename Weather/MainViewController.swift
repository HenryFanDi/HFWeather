//
//  MainViewController.swift
//  Weather
//
//  Created by HenryFan on 19/5/2016.
//  Copyright © 2016 HenryFanDi. All rights reserved.
//

import UIKit
import CoreLocation
import Darwin

class MainViewController: UIViewController, CLLocationManagerDelegate {
  
  fileprivate var colors = [] as [UIColor]
  fileprivate let greenColor = UIColor.init(red: 130.0/255.0, green: 255.0/255.0, blue: 230.0/255.0, alpha: 1.0)
  fileprivate let blueColor = UIColor.init(red: 102.0/255.0, green: 204.0/255.0, blue: 255.0/255.0, alpha: 1.0)
  fileprivate let pinkColor = UIColor.init(red: 255.0/255.0, green: 210.0/255.0, blue: 250.0/255.0, alpha: 1.0)
  
  fileprivate let locationManager = CLLocationManager()
  
  @IBOutlet weak var countryLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupMainViewController()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: Private
  
  fileprivate func setupMainViewController() {
    colors = [greenColor, blueColor, pinkColor]
    getUserLocation()
    fetchWeatherAPI()
  }
  
  fileprivate func getUserLocation() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  fileprivate func fetchWeatherAPI() {
    if let userLocation = locationManager.location as CLLocation? {
      let parameters = [
        "latitude": String(format: "%f", userLocation.coordinate.latitude),
        "longitude": String(format: "%f", userLocation.coordinate.longitude)
        ] as Dictionary<String, String>
      unowned let unownedSelf = self
      APIHelper.sharedInstance.fetchAPIDataWithAPIType(.weatherAPI, parameters: parameters) { (result, statusCode, error) in
        let weather = result as? Dictionary <String, AnyObject>
        if weather != nil {
          unownedSelf.countryLabel.text = weather!["sys"]!["country"] as? String
          unownedSelf.cityLabel.text = weather!["name"] as? String
          unownedSelf.temperatureLabel.text = String(format: "%.0f", (weather!["main"]!["temp"] as? CGFloat)! / 10.0)
          
          var statusStr = ""
          for dict in (weather!["weather"] as! [Dictionary <String, AnyObject>]) {
            let model = WeatherModel.init(weatherDescription: dict["description"] as? String,
                                          icon: dict["icon"] as? String,
                                          weatherID: dict["id"] as? String,
                                          main: dict["main"] as? String)
            let str = model?.weatherDescription?.capitalized(with: Locale.current)
            statusStr = statusStr + String(format: "%@ ", str!)
          }
          unownedSelf.statusLabel.text = statusStr
          unownedSelf.transitBackgroundColorAnimation()
        }
      }
    }
  }
  
  fileprivate func transitBackgroundColorAnimation() {
    unowned let unownedSelf = self
    UIView.animate(withDuration: 0.3, animations: {
      unownedSelf.view.backgroundColor = unownedSelf.colors[Int(arc4random_uniform(2))]
      unownedSelf.countryLabel.textColor = UIColor.white
      unownedSelf.cityLabel.textColor = UIColor.white
      unownedSelf.temperatureLabel.textColor = UIColor.white
      unownedSelf.statusLabel.textColor = UIColor.white
    })
  }
  
}
