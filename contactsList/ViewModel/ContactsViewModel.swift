//
//  ContactsViewModel.swift
//  contactsList
//
//  Created by K V Jagadeesh babu on 22/01/25.
//

import Foundation

//class ContactsViewModel {
//    
//    private let apiManager = APIManager()
//    var contacts: [Contact] = []
//    var onContactsUpdated: (() -> Void)?
//        var onErrorOccurred: ((Error) -> Void)?
//    
//    func fetchContacts() {
//            apiManager.fetchContacts { [weak self] result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let contacts):
//                        self?.contacts = contacts
//                        self?.onContactsUpdated?()
//                    case .failure(let error):
//                        print("\(error)")
//                        self?.onErrorOccurred?(error)
//
//                    }
//                }
//            }
//        }
//    
//}

class ContactsViewModel {
    private let apiService: APIManager
    private let coreDataManager: CoreDataManager
    
    var onContactsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    var contacts: [Contact] = [] {
        didSet {
            onContactsUpdated?()
        }
    }
    
    init(apiService: APIManager, coreDataManager: CoreDataManager) {
        self.apiService = apiService
        self.coreDataManager = coreDataManager
    }
    
    func fetchContacts(refresh: Bool = false) {
        if refresh {
            contacts.removeAll()
        }
        
        apiService.fetchContacts { [weak self] result in
            switch result {
            case .success(let newContacts):
                self?.contacts = newContacts
                self?.coreDataManager.saveContacts(newContacts)
            case .failure(let error):
                self?.onError?(error.localizedDescription)
                self?.loadContactsFromDatabase()
            }
        }
    }
    
    func loadContactsFromDatabase() {
        contacts = coreDataManager.fetchContacts()
    }
}
