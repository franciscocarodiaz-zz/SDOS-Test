//
//  Task.swift
//  SDOSTest
//
//  Created by Francisco Caro Diaz on 12/06/15.
//  Copyright (c) 2015 FCD. All rights reserved.
//

import Foundation
import CoreData

class Task: NSManagedObject {

    @NSManaged var descripcion: String
    @NSManaged var duration: String
    @NSManaged var datetask: NSDate
    @NSManaged var finished: String
    @NSManaged var isvalid: String
    @NSManaged var user: Usuario
    @NSManaged var typetask: TypeTask

}
