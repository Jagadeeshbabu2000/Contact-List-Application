//
//  ViewController.swift
//  contactsList
//
//  Created by K V Jagadeesh babu on 22/01/25.
//

import UIKit
import CoreData

class ContactListVC: UIViewController {

    @IBOutlet weak var contactTableView: UITableView!
    
    private let viewModel = ContactsViewModel(apiService: APIManager(), coreDataManager: CoreDataManager.shared)
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupRefreshControl()
        viewModel.fetchContacts()
        bindViewModel()
    }
    
    private func setupTableView() {
        contactTableView.delegate = self
        contactTableView.dataSource = self
        contactTableView.register(UINib(nibName: "ContactListCell", bundle: nil), forCellReuseIdentifier: "ContactListCell")
    }

    private func setupRefreshControl() {
        contactTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = .lightGray
    }
    
    private func bindViewModel() {
        viewModel.onContactsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.contactTableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                print("Error: \(error)")
            }
        }
    }
    
    @objc private func refreshData() {
        viewModel.fetchContacts(refresh: true)
    }
}

// MARK: Extension Tableview delegate and datasource
extension ContactListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell", for: indexPath) as! ContactListCell
        cell.selectionStyle = .none
        let contact = viewModel.contacts[indexPath.row]
        cell.idTitleLbl.text = "id: \(contact.id)"
        cell.emailTitleLbl.text = "email: \(contact.email)"
        cell.nameTitleLbl.text = "name: \(contact.name)"
        cell.phoneNumberTitleLbl.text = "phoneNumber: \(contact.phone)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
