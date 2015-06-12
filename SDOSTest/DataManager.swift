//
//  DataManager.swift
//  SDOSTest
//
//  Created by Francisco Caro Diaz on 10/06/15.
//  Copyright (c) 2015 FCD. All rights reserved.
//

import Foundation

let UserSDOSURL = "http://s457595517.mialojamiento.es/ios/sdos/usersdata.json"

class DataManager {
  
  class func getUsersSDOSDataFromUrlWithSuccess(success: ((data: NSData!) -> Void)) {
    loadDataFromURL(NSURL(string: UserSDOSURL)!, completion:{(data, error) -> Void in
        if let urlData = data {
          success(data: urlData)
        }
    })
  }
  
  class func getUsersSDOSDataFromFileWithSuccess(success: ((data: NSData) -> Void)) {
    //1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
      //2
      let filePath = NSBundle.mainBundle().pathForResource("usersdata",ofType:"json")

      var readError:NSError?
      if let data = NSData(contentsOfFile:filePath!,
        options: NSDataReadingOptions.DataReadingUncached,
        error:&readError) {
        success(data: data)
      }
    })
  }
  
  class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
    var session = NSURLSession.sharedSession()
    
    // Use NSURLSession to get data from an NSURL
    let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
      if let responseError = error {
        completion(data: nil, error: responseError)
      } else if let httpResponse = response as? NSHTTPURLResponse {
        if httpResponse.statusCode != 200 {
          var statusError = NSError(domain:"com.sdos", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
          completion(data: nil, error: statusError)
        } else {
          completion(data: data, error: nil)
        }
      }
    })
    
    loadDataTask.resume()
  }
    
}