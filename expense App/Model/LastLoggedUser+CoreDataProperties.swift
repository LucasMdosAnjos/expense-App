//
//  LastLoggedUser+CoreDataProperties.swift
//  expense App
//
//  Created by Lucas Monteiro on 31/03/24.
//
//

import Foundation
import CoreData


extension LastLoggedUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastLoggedUser> {
        return NSFetchRequest<LastLoggedUser>(entityName: "LastLoggedUser")
    }

    @NSManaged public var email: String?

}

extension LastLoggedUser : Identifiable {

}
