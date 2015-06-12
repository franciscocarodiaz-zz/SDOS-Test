//
//  UserMethods.swift
//  SDOSTest
//
//  Created by Francisco Caro Diaz on 12/06/15.
//  Copyright (c) 2015 FCD. All rights reserved.
//

import Foundation
import CoreData

extension Usuario{
    
    func addTaskByID(taskId:String) {
        var tasks = self.mutableSetValueForKey("tasks");
        
        let managedContext = SDOSCoreDataStack.sharedManager.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"TypeTask")
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "ident == %@", taskId)
        fetchRequest.predicate = predicate
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            for taskType in results {
                var res = taskType as! TypeTask
                let task = Task(userTask: self, description: "Desc", duration: "3", typeTaskItem : res)
                addTask(task);
            }
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    func addTask(task:Task) {
        var tasks = self.mutableSetValueForKey("tasks");
        tasks.addObject(task)
    }
    
    func calculateNumberOfHoursOfTasksToBeDone() -> String{
    
        let managedContext = SDOSCoreDataStack.sharedManager.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Task")
        
        let sortDescriptor = NSSortDescriptor(key: "duration", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "finished == %@ AND user == %@", argumentArray: ["0", self])
        fetchRequest.predicate = predicate
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        var numberOfHoursOfTasksToBeDone : Int = 0
        if let results = fetchedResults {
            numberOfHoursOfTasksToBeDone = 0
            for task in results {
                if let result_number = task.valueForKey("duration") as? String
                {
                    numberOfHoursOfTasksToBeDone = numberOfHoursOfTasksToBeDone + result_number.toInt()!
                }
            }
            return String(numberOfHoursOfTasksToBeDone)
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
            return "0"
        }
        
        
    }
    
    func getSkills() -> Array<String> {
        var tasks = self.mutableSetValueForKey("tasks");
        var tasksArray : [String] = []
        var tasksObj = tasks.allObjects as NSArray  //NSArray
        
        for task in tasksObj {
            var t = task as! Task
            var name = t.valueForKey("name") as! String
            tasksArray.append(name);
        }
        
        return tasksArray
    }
    
    convenience init(name: String, password: String, phone: String, code : String, usertype: String, skill: Array<String>) {
        
        var moc: NSManagedObjectContext = SDOSCoreDataStack.sharedManager.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Usuario", inManagedObjectContext: moc)!
        self.init(entity: entity, insertIntoManagedObjectContext: moc)
        self.name = name
        self.password = password
        self.phone = phone
        self.code = code
        self.usertype = usertype
        for taskId in skill {
            addTaskByID(taskId)
        }
        self.datetask = NSDate()
        self.hours = calculateNumberOfHoursOfTasksToBeDone()
        
        var error: NSError?
        if !moc.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }else{
            println("New user saved in database: \(description)")
        }
    }
    
    override var description: String {
        var taskList = [String]()
        for taskItem in tasks {
            var task = taskItem as! Task
            var taskDuration = task.valueForKey("duration") as! String
            var taskType = task.valueForKey("typetask") as! TypeTask
            var taskTypeName = taskType.valueForKey("name") as! String
            var taskItemFormatted = "\(taskTypeName)+\(taskDuration)h."
            taskList.append(taskItemFormatted)
        }
        return "Name: \(name), phone: \(phone), type: \(usertype), hours: \(hours), tasks: \(taskList)\n"
    }

}
