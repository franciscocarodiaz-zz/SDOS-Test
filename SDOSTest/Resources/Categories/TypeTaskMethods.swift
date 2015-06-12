//
//  TypeTaskMethods.swift
//  SDOSTest
//
//  Created by Francisco Caro Diaz on 12/06/15.
//  Copyright (c) 2015 FCD. All rights reserved.
//

import Foundation
import CoreData

extension TypeTask{
    
    convenience init(name: String, ident: String) {
        var moc: NSManagedObjectContext = SDOSCoreDataStack.sharedManager.managedObjectContext!
        let entity = NSEntityDescription.entityForName("TypeTask", inManagedObjectContext: moc)!
        self.init(entity: entity, insertIntoManagedObjectContext: moc)
        self.name = name
        self.ident = ident
        
        var error: NSError?
        if !moc.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }else{
            println("New type task saved in database: \(name)")
        }
    }
    
    override var description: String {
        return "Name: \(name)\n"
    }
}