//
//  TypeTask.swift
//  SDOSTest
//
//  Created by Francisco Caro Diaz on 12/06/15.
//  Copyright (c) 2015 FCD. All rights reserved.
//

import Foundation
import CoreData

class TypeTask: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var ident: String
    @NSManaged var tasksOfTypeTask: NSSet

}
