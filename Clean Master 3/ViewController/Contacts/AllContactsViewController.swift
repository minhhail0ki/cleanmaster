//
//  AllContactsViewController.swift
//  Clean Master 3
//
//  Created by Le Minh Hai on 29/12/2021.
//

import UIKit
import Contacts
import ContactsUI

var arrToDeleteContact = [CNContact]()

class AllContactsViewController: UIViewController, CNContactPickerDelegate, UITableViewDelegate, UITableViewDataSource, CNContactViewControllerDelegate, UINavigationControllerDelegate,UISearchBarDelegate {
    
    var titleName:String = ""
    var namesDictionary = [String: [CNContact]]()
    var nameSectionTitles = [String]()
    var names = [String]()
    var results: [CNContact] = []
    var hung = [String]()
    var DidSelect = [CNContact]()
    var index = 0
    
    @IBOutlet weak var AllContactsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func Back(){
        self.dismiss(animated: true)
    }
    @objc func back1() {
        self.dismiss(animated: true, completion: nil) }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AllContactsTableView.delegate = self
        AllContactsTableView.dataSource = self
        searchBar.delegate = self
        getAllContact()
        
    }
    func getAllContact(){
        let fetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactMiddleNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor,CNContactPhoneNumbersKey as CNKeyDescriptor])
        
        fetchRequest.sortOrder = CNContactSortOrder.userDefault
        
        let store = CNContactStore()
        
        do {
            try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                
                print(contact.phoneNumbers.first?.value ?? "no")
                print(contact.phoneNumbers.count)
                print(contact.phoneNumbers.first?.value.stringValue ?? "") // hiển thị số điện thoại
                
                let fullName = "\(contact.givenName) \(contact.middleName) \(contact.familyName)"
                print(fullName)
                print(contact.emailAddresses.first?.value ?? "") // Lấy ra email của contact
                self.results.append(contact)
                self.names.append(fullName)
            })
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        //  AdmobManager.shared.logEvent()a
        arrToDeleteContact = []
        
        for name in results {
            var fullName = "\(name.givenName) \(name.middleName) \(name.familyName)"
            var nameKey = String(fullName.prefix(1))
            if nameKey == " "{
                fullName = String(fullName.dropFirst(1))
                nameKey = String(fullName.prefix(1))
                if nameKey == " "{
                    fullName = String(fullName.dropFirst(1))
                    nameKey = String(fullName.prefix(1))
                }
            }
            
            if var nameValues = namesDictionary[nameKey] {
                nameValues.append(name)
                namesDictionary[nameKey] = nameValues
            } else {
                namesDictionary[nameKey] = [name]
            }
        }
        // 2 The keys of the carsDictionary are sorted by alphabetical order.
        nameSectionTitles = [String](namesDictionary.keys)
        nameSectionTitles = nameSectionTitles.sorted(by: { $0 < $1 })
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if index == 0{
            let nameKey = nameSectionTitles[indexPath.section]
            if let nameValues = namesDictionary[nameKey] {
                let store = CNContactStore()
                var contact = nameValues[indexPath.row]
                if !contact.areKeysAvailable([CNContactViewController.descriptorForRequiredKeys()]) {
                    do {
                        contact = try store.unifiedContact(withIdentifier: contact.identifier, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
                    }
                    catch { }
                }
                let viewControllerforContact = CNContactViewController(for: contact)
                let nav = UINavigationController(rootViewController: viewControllerforContact)
                let backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back1))
                viewControllerforContact.navigationItem.leftBarButtonItem = backButton
                viewControllerforContact.displayedPropertyKeys = [CNContactPhoneNumbersKey, CNContactGivenNameKey]
                self.present(nav, animated: true, completion: nil)
            }
        }else{
            for i in hung{
                for j in 0..<results.count{
                    if i == "\(results[j].givenName) \(results[j].middleName) \(results[j].familyName)"{
                        DidSelect.append(results[j])
                    }
                }
            }
            let store = CNContactStore()
            var contact = DidSelect[indexPath.row]
            if !contact.areKeysAvailable([CNContactViewController.descriptorForRequiredKeys()]) {
                do {
                    contact = try store.unifiedContact(withIdentifier: contact.identifier, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
                }
                catch { }
            }
            let viewControllerforContact = CNContactViewController(for: contact)
            let nav = UINavigationController(rootViewController: viewControllerforContact)
            let backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back1))
            viewControllerforContact.navigationItem.leftBarButtonItem = backButton
            viewControllerforContact.displayedPropertyKeys = [CNContactPhoneNumbersKey, CNContactGivenNameKey]
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            index = 0
        }else{
            index = 1
        }
        hung = searchText.isEmpty ? names : names.filter({(dataString: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        AllContactsTableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if index == 0{
            return nameSectionTitles.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if index == 0{
            let nameKey = nameSectionTitles[section]
            if let nameValues = namesDictionary[nameKey] {
                return nameValues.count
            }
            return 0
        }
        return hung.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if index == 0{
            let nameKey = nameSectionTitles[indexPath.section]
            if let nameValues = namesDictionary[nameKey] {
                cell.textLabel?.text = "\(nameValues[indexPath.row].givenName) \(nameValues[indexPath.row].middleName) \(nameValues[indexPath.row].familyName)"
            }
            return cell
        }
        cell.textLabel?.text = "\(hung[indexPath.row])"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if index == 0{
            return nameSectionTitles[section]
        }
        return ""
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nameSectionTitles
    }
}

