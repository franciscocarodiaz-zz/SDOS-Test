//
//  Usuario.swift
//  
//
//  Created by Francisco Caro Diaz on 11/06/15.
//
//

import Foundation
import CoreData

class UsuarioAux: NSManagedObject {

    @NSManaged var code: String
    @NSManaged var name: String
    @NSManaged var datetask: NSDate
    @NSManaged var password: String
    @NSManaged var phone: String
    @NSManaged var skills: AnyObject
    @NSManaged var usertype: String
    
    convenience init(name: String, password: String, phone: String, code : String, usertype: String, skill: Array<Int>, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entityForName("Usuario", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.name = name
        self.password = password
        self.phone = phone
        self.code = code
        self.usertype = usertype
        self.skills = skill
        self.datetask = NSDate()
        
        var error: NSError?
        if !context.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    override var description: String {
        return "Name: \(name), phone: \(phone), type: \(usertype), skill: \(skills)\n"
    }
    
    /*
    init(id: Int?, password: String?, name: String?, phone: String?, code: String?, user_type: String?, skill: Array<Int>?) {
        self.id = id ?? 0
        self.password = password ?? ""
        self.name = name ?? ""
        self.phone = phone ?? ""
        self.code = name ?? ""
        self.user_type = user_type ?? ""
        self.skill = skill!
    }
    */

}
