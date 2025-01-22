//
//  CoreDataSaving.swift
//  contactsList
//
//  Created by K V Jagadeesh babu on 22/01/25.
//

import UIKit
import CoreData


class CoreDataManager {
    
    static let shared = CoreDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveContacts(_ contacts: [Contact]) {
            deleteAllContacts()
            contacts.forEach { contact in
                let entity = ContactEntity(context: context)
                entity.id = Int32(contact.id)
                entity.name = contact.name
                entity.phone = contact.phone
                entity.email = contact.email
            }
            try? context.save()
        }
    
    func fetchContacts() -> [Contact] {
           let request: NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
           let entities = (try? context.fetch(request)) ?? []
           return entities.map { Contact(id: Int($0.id), name: $0.name ?? "", phone: $0.phone ?? "", email: $0.email ?? "") }
       }
       
       func deleteAllContacts() {
           let request: NSFetchRequest<NSFetchRequestResult> = ContactEntity.fetchRequest()
           let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
           try? context.execute(deleteRequest)
       }
}
