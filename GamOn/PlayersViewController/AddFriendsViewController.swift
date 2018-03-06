//
//  ViewController.swift
//  GamOn
//
//  Created by Shahla Almasri Hafez on 2/18/18.
//

import UIKit
import Contacts

class AddFriendsViewController: UIViewController {
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    ///
    ///
    ///
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.backgroundColor = .specialPurple
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 50
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
    }
}

// MARK: UITableViewDataSource
extension AddFriendsViewController: UITableViewDataSource {
    ///
    ///
    ///
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    ///
    ///
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return AppDelegate.favorites.isEmpty ? 1 : AppDelegate.favorites.count
        case 1:
            return AppDelegate.recents.isEmpty ? 1 : AppDelegate.recents.count
        case 2:
            return AppDelegate.contacts.isEmpty ? 1 : AppDelegate.contacts.count
        default:
            return 0
        }
    }
    
    ///
    ///
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            if AppDelegate.favorites.isEmpty {
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.text = "No favorite friends"
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell {
                let contact = AppDelegate.favorites[indexPath.row]
                cell.delegate = self
                cell.label?.text = contact.firstName + " " + contact.lastName
                cell.contactIdentifier = contact.identifier
                return cell
            }
            
        case 1:
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = "No recent friends"
            
            
        case 2:
            if AppDelegate.contacts.isEmpty {
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.text = "No contacts"
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell {
                let contact = AppDelegate.contacts[indexPath.row]
                cell.delegate = self
                cell.label?.text = contact.firstName + " " + contact.lastName
                cell.contactIdentifier = contact.identifier
                return cell
            }
            
        default:
            break
        }
        
        cell.textLabel?.textColor = .specialPurple
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: UITableViewDelegate
extension AddFriendsViewController: UITableViewDelegate {
    ///
    ///
    ///
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = UILabel()
        title.backgroundColor = .white
        title.textColor = .specialPurple
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 25)
        
        switch section {
        case 0:
            title.text = "Favorites"
        case 1:
            title.text = "Recents"
        case 2:
            title.text = "Contacts"
        default:
            title.text = ""
        }
        
        return title
    }
    
    ///
    ///
    ///
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let flowLayout = UICollectionViewFlowLayout()
        let vc = GamesViewController(collectionViewLayout: flowLayout)
        flowLayout.itemSize = CGSize(width: vc.collectionView!.frame.width / 3.5, height: 100)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: ContactCellDelegate
extension AddFriendsViewController: ContactCellDelegate {
    ///
    ///
    ///
    func didTapFavoriteButton(on identifier: String) {
        // If the contact is in favorite, then unfavorite it. Otherwise, add it to the favorites list.
        let index = AppDelegate.indexInFavorite(identifier: identifier)
        if index != -1 {
            let contact = AppDelegate.favorites.remove(at: index)
            PlayersManagedObject.shared.delete(player: contact)
        } else {
            if let contact = AppDelegate.contacts.filter( { $0.identifier == identifier }).first {
                AppDelegate.favorites.insert(contact, at: 0)
                PlayersManagedObject.shared.save(player: contact)
            }
        }
        tableView.reloadData()
    }
}
