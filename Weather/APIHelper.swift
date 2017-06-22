//
//  APIHelper.swift
//  Weather
//
//  Created by HenryFan on 30/5/2016.
//  Copyright © 2016 HenryFanDi. All rights reserved.
//

import UIKit

typealias APIHelperCompletionHandler = (_ result: AnyObject?, _ statusCode: Int?, _ error: Error?) -> Void

class APIHelper: NSObject {
  
  enum APIType {
    case weatherAPI
  }
  
  let sessionConfig: URLSessionConfiguration
  
  // MARK: Singleton Pattern
  
  static let sharedInstance = APIHelper()
  
  // MARK: Initialize
  
  override init() {
    sessionConfig = URLSessionConfiguration.ephemeral
    super.init()
  }
  
  func fetchAPIDataWithAPIType(_ apiType: APIType, parameters: Any?, completionHandler: @escaping APIHelperCompletionHandler) {
    guard parameters != nil else {
      return
    }
    
    var URLString = ""
    let appID = "d353523e01169c4d061044c327a77ecb"
    let request = NSMutableURLRequest()
    switch apiType {
    case .weatherAPI:
      let latitude = (parameters as! Dictionary <String, String>)["latitude"]! as String
      let longitude = (parameters as! Dictionary <String, String>)["longitude"]! as String
      URLString = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&APPID=\(appID)"
      break
    }
    request.url = URL(string: URLString)
    request.timeoutInterval = 10.0
    
    let currentTask = URLSession.shared.dataTask(with: request as URLRequest) { (theData, theResponse, theError) in
      let resultError = theError
      let statusCode = (theResponse as? HTTPURLResponse)?.statusCode
      let jsonResult = try? JSONSerialization.jsonObject(with: theData!, options: JSONSerialization.ReadingOptions.mutableContainers)
      DispatchQueue.main.async(execute: {
        completionHandler(jsonResult as AnyObject, statusCode, resultError)
      })
    }
    currentTask.resume()
  }
  
}
