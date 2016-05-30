//
//  APIHelper.swift
//  Weather
//
//  Created by HenryFan on 30/5/2016.
//  Copyright © 2016 HenryFanDi. All rights reserved.
//

import UIKit

typealias APIHelperCompletionHandler = (result: AnyObject?, statusCode: Int?, error: NSError?) -> Void

class APIHelper: NSObject {
  
  enum APIType {
    case WeatherAPI
  }
  
  let sessionConfig: NSURLSessionConfiguration
  
  // MARK: Singleton Pattern
  
  class var sharedInstance: APIHelper { // The traditional Objc approach ported to Swift
    struct Static {
      static var onceToken: dispatch_once_t = 0
      static var instance: APIHelper? = nil
    }
    dispatch_once(&Static.onceToken) {
      Static.instance = APIHelper()
    }
    return Static.instance!
  }
  
  // MARK: Initialize
  
  override init() {
    sessionConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    super.init()
  }

  func fetchAPIDataWithAPIType(apiType: APIType, parameters: AnyObject?, completionHandler: APIHelperCompletionHandler) {
    var URLString = ""
    let request = NSMutableURLRequest()
    switch apiType {
    case .WeatherAPI:
      let latitude = (parameters as! Dictionary <String, String>)["latitude"]! as String
      let longitude = (parameters as! Dictionary <String, String>)["longitude"]! as String
      URLString = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)"
      break
    }
    request.URL = NSURL(string: URLString)
    request.timeoutInterval = 10.0
    
    let currentSession = NSURLSession(configuration: sessionConfig)
    let currentTask = currentSession.dataTaskWithRequest(request) { (theData, theResponse, theError) in
      let resultError: NSError? = theError
      let statusCode = (theResponse as? NSHTTPURLResponse)?.statusCode
      let jsonResult: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(theData!, options: NSJSONReadingOptions.MutableContainers)
      dispatch_async(dispatch_get_main_queue(), { 
        completionHandler(result: jsonResult, statusCode: statusCode, error: resultError)
      })
    }
    currentTask.resume()
  }
  
}
