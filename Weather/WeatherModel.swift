//
//  WeatherModel.swift
//  Weather
//
//  Created by HenryFan on 1/6/2016.
//  Copyright © 2016 HenryFanDi. All rights reserved.
//

import UIKit

class WeatherModel: NSObject {
  
  var weatherDescription: String?
  var icon: String?
  var weatherID: String?
  var main: String?
  
  init?(weatherDescription: String?, icon: String?, weatherID: String?, main: String?) {
    self.weatherDescription = weatherDescription
    self.icon = icon
    self.weatherID = weatherID
    self.main = main
  }
  
}
