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
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getUserLocation()
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
    
    if let userLocation = locationManager.location as CLLocation? {
      print(userLocation)
    }
  }
  
}
