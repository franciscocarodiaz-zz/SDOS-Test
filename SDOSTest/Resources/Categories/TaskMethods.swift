//
//  TaskMethods.swift
//  SDOSTest
//
//  Created by Francisco Caro Diaz on 12/06/15.
//  Copyright (c) 2015 FCD. All rights reserved.
//

import Foundation
import CoreData

extension Task{
    
    func isValid() -> Bool{
        if self.isvalid == "1"{
            return true
        }else{
            return false
        }
        
    }
    
    convenience init(description: String, duration: String, typeTaskItem : TypeTask) {
        var moc: NSManagedObjectContext = SDOSCoreDataStack.sharedManager.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: moc)
        self.init(entity: entity!, insertIntoManagedObjectContext: moc)
        self.descripcion = description
        self.duration = duration
        self.datetask = NSDate()
        self.finished = "0"
        
        self.typetask = typeTaskItem
        // 1. Search user
        var ident = self.typetask.valueForKey("ident") as? String
        
        var userItemWithSkill : Usuario
        let managedContext = SDOSCoreDataStack.sharedManager.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Usuario")
        
        let sortDescriptor = NSSortDescriptor(key: "hours.intValue", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        //let predicate = NSPredicate(format: "ANY tasks == %@ AND usertype == %@", argumentArray: [skill, "1"])
        let predicate = NSPredicate(format: "usertype == %@", "1")
        fetchRequest.predicate = predicate
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        var found = false
        if let results = fetchedResults {
            if results.count>0{
                for user in results {
                    var userItem = user as! Usuario
                    var skills = userItem.valueForKey("tasks") as! NSSet
                    for task in skills{
                        var taskItem = task as! Task
                        var typetaskItem = taskItem.valueForKey("typetask") as! TypeTask
                        var typetaskItemIdent = typetaskItem.valueForKey("ident") as! String
                        
                        if typetaskItemIdent == ident && !found{
                            found = true
                            self.user = userItem
                            self.isvalid = "1"
                            var numberOfHoursOfTasksToBeDone : Int = 0
                            let result_number = userItem.hours
                            numberOfHoursOfTasksToBeDone = duration.toInt()! + result_number.toInt()!
                            
                            userItem.hours = String(numberOfHoursOfTasksToBeDone)
                            
                            
                            
                            //userItem.hours = Usuario.calculateNumberOfHoursOfTasksToBeDone(self.user)()
                            var error: NSError?
                            if !moc.save(&error) {
                                println("Could not save \(error), \(error?.userInfo)")
                            }else{
                                self.user.addTask(self)
                                println("Task \(self.isvalid)  \(self.description) assigned to \(self.user.name)")
                                
                            }
                        }
                    }
                }
                
            }
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
    }
    
    convenience init(userTask: Usuario, description: String, duration: String, typeTaskItem : TypeTask) {
        var moc: NSManagedObjectContext = SDOSCoreDataStack.sharedManager.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: moc)
        self.init(entity: entity!, insertIntoManagedObjectContext: moc)
        self.descripcion = description
        self.duration = duration
        self.datetask = NSDate()
        self.finished = "0"
        self.typetask = typeTaskItem
        self.user = userTask;
        self.isvalid = "1"
        
        var error: NSError?
        if !moc.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    override var description: String {
        return "Duration: \(duration), type: \(typetask.description), user: \(user.description)\n"
    }
    
    
}