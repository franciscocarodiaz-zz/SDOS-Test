//
//  Usuario.swift
//  SDOSTest
//
//  Created by Francisco Caro Diaz on 12/06/15.
//  Copyright (c) 2015 FCD. All rights reserved.
//

import Foundation
import CoreData

class Usuario: NSManagedObject {

    @NSManaged var code: String
    @NSManaged var datetask: NSDate
    @NSManaged var name: String
    @NSManaged var password: String
    @NSManaged var phone: String
    @NSManaged var hours: String
    @NSManaged var usertype: String
    @NSManaged var tasks: NSSet

}
