//
//  ContactEntity+CoreDataProperties.swift
//  contactsList
//
//  Created by K V Jagadeesh babu on 22/01/25.
//
//

import Foundation
import CoreData


extension ContactEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactEntity> {
        return NSFetchRequest<ContactEntity>(entityName: "ContactEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var email: String?

}

extension ContactEntity : Identifiable {

}
