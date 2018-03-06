//
//  LaunchScreen.swift
//  GamOn
//
//  Created by Shahla Almasri Hafez on 2/19/18.
//

import UIKit
import Contacts
import CoreData

class LaunchScreenViewController: UIViewController {
    let contactStore = CNContactStore()
    
    ///
    ///
    ///
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestAccessToContacts(completionHandler: retrieveContacts)
        PlayersManagedObject.shared.loadFavorites()
    }
    
    ///
    ///
    ///
    func requestAccessToContacts(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            showSettingsAlert(completionHandler)
        case .restricted, .notDetermined:
            contactStore.requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(completionHandler)
                    }
                }
            }
        }
    }
    
    ///
    ///
    ///
    private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: "GamOn requires access to Contacts",
                                      message: "Do you want to open settings and grant permission to contacts?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
            completionHandler(false)
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
            UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
        })
        present(alert, animated: true)
    }
    
    ///
    ///
    ///
    func retrieveContacts(accessGranted: Bool) {
        if !accessGranted { return }
        
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stop) in
                AppDelegate.contacts.append(Player(contact: contact))
            }
        } catch {
            print("unable to fetch contacts")
        }
        
        performSegue(withIdentifier: "ToAddFriends", sender: self)
    }
}
