//
//  DataManager.swift
//  SDOSTest
//
//  Created by Francisco Caro Diaz on 10/06/15.
//  Copyright (c) 2015 FCD. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class DataManager {
    
    class func getSDOSDataWithSuccess(success: ((res: Bool) -> Void)) {
        
        //DataManager.getTypeTaskSDOSDataFromUrlWithSuccess(URL_TASKS_SDOS)
        
        loadDataFromURL(NSURL(string: URL_TASKS_SDOS)!, completion:{(data, error) -> Void in
            if let urlData = data {
                let json = JSON(data : urlData)
                
                if let total_count = json["total_count"].int {
                    println("total_count: \(total_count)")
                }
                
                if let appArray = json["items"].array {
                    var users = [Task]()
                    
                    for appDict in appArray {
                        var name: String? = appDict["name"].string
                        var ident: String? = appDict["ident"].string
                        
                        let task = TypeTask(name: name!, ident: ident!)
                        
                    }
                }
            }
            
            DataManager.getUsersSDOSDataFromUrlWithSuccess(URL_USERS_SDOS) { (data) -> Void in
                let json = JSON(data: data)
                
                if let total_count = json["total_count"].int {
                    println("total_count: \(total_count)")
                }
                
                if let appArray = json["items"].array {
                    var users = [Usuario]()
                    
                    for appDict in appArray {
                        var name: String? = appDict["name"].string
                        var password: String? = appDict["name"].string
                        var phone: String? = appDict["phone"].string
                        var code: String? = appDict["code"].string
                        var usertype: String? = appDict["usertype"].string
                        
                        var skills = [String]()
                        if let skillArray = appDict["skill"].array {
                            for skillDict in skillArray {
                                var skillItem: String? = skillDict.string
                                skills.append(skillItem!)
                            }
                        }
                        
                        let user = Usuario(name: name!, password: password!, phone: phone!, code: code!, usertype: usertype!, skill: skills)
                        
                    }
                    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    prefs.setInteger(1, forKey: "ISFIRSTTIME")
                    prefs.synchronize()
                }
                success(res: true)
            }
            
        })
        
        
    }
  
    class func getUsersSDOSDataFromUrlWithSuccess(url : String, success: ((data: NSData!) -> Void)) {
        loadDataFromURL(NSURL(string: url)!, completion:{(data, error) -> Void in
            if let urlData = data {
                success(data: urlData)
            }
        })
    }
    
    class func getUserWithSkill(skill : String, success: ((userItem: Usuario!) -> Void)) {
        var userItemWithSkill : Usuario
        let managedContext = SDOSCoreDataStack.sharedManager.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Usuario")
        
        let sortDescriptor = NSSortDescriptor(key: "hours", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        //let predicate = NSPredicate(format: "ANY tasks == %@ AND usertype == %@", argumentArray: [skill, "1"])
        let predicate = NSPredicate(format: "usertype == %@", "1")
        fetchRequest.predicate = predicate
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            if results.count>0{
                for user in results {
                    var userItem = user as! Usuario
                    var skills = userItem.valueForKey("tasks") as! NSSet
                    if (skills.containsObject(skill)){
                        var hours = userItem.valueForKey("hours") as! String
                        println("Found user with skill \(skill), and lower number of hours \(hours)")
                        success(userItem: userItem)
                    }
                }
                
            }
            /*
            for item in results {
                var userItem = item as! Usuario
                //var name: String? = typeTask.valueForKey("name") as? String
            }
            */
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
    }
    
    class func getTypeTaskList(success: ((data: [TypeTask]) -> Void)) {
        var typeTaskList = [TypeTask]()
        let managedContext = SDOSCoreDataStack.sharedManager.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"TypeTask")
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            for typeTask in results {
                var typeTask = typeTask as! TypeTask
                //var name: String? = typeTask.valueForKey("name") as? String
                typeTaskList.append(typeTask)
            }
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        success(data: typeTaskList)
        
    }
    
    class func getTypeTaskSDOSDataFromUrlWithSuccess(url : String) {
        loadDataFromURL(NSURL(string: url)!, completion:{(data, error) -> Void in
            if let urlData = data {
                let json = JSON(data : urlData)
                
                if let total_count = json["total_count"].int {
                    println("total_count: \(total_count)")
                }
                
                if let appArray = json["items"].array {
                    var users = [Task]()
                    
                    for appDict in appArray {
                        var name: String? = appDict["name"].string
                        var ident: String? = appDict["ident"].string
                        
                        let task = TypeTask(name: name!, ident: ident!)
                        
                    }
                }
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