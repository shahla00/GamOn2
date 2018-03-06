//
//  PlayersManagedObject.swift
//  GamOn
//
//  Created by Shahla Almasri Hafez on 2/25/18.
//  Copyright © 2018 MrRobot. All rights reserved.
//

import CoreData
import UIKit

class PlayersManagedObject {
    private static let _shared = PlayersManagedObject()
    static var shared: PlayersManagedObject {
        return _shared
    }
    
    final let FavoritesEntity = "FavoritePlayer"
    final let RecentsEntity = "FavoritePlayer"
    
    ///
    /// Loads the list of favoriates players from the db
    ///
    func loadFavorites() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: FavoritesEntity)
        request.returnsObjectsAsFaults = false
        do {
            let context = persistentContainer.viewContext
            let result = try context.fetch(request)
            for object in result as! [NSManagedObject] {
                let player = Player()
                player.firstName = object.value(forKey: "firstName") as! String
                player.lastName = object.value(forKey: "lastName") as! String
                player.identifier = object.value(forKey: "identifier") as! String
                AppDelegate.favorites.append(player)
            }
        } catch {
            print("Failed to load favorites")
        }
    }
    
    ///
    /// Saves the contact to the favorites list.
    ///
    func save(player: Player) {
        let entity = NSEntityDescription.entity(forEntityName: FavoritesEntity, in: persistentContainer.viewContext)
        let managedObject = NSManagedObject(entity: entity!, insertInto: persistentContainer.viewContext)
        managedObject.setValue(player.firstName, forKey: "firstName")
        managedObject.setValue(player.lastName, forKey: "lastName")
        managedObject.setValue(player.identifier, forKey: "identifier")
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed saving contact to favorites")
        }
    }
    
    ///
    /// Deletes the contact to the favorites list.
    ///
    func delete(player: Player) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: FavoritesEntity)
        request.predicate = NSPredicate(format: "identifier = %@", player.identifier)
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            for object in result as! [NSManagedObject] {
                persistentContainer.viewContext.delete(object)
            }
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to delete a contact from favorites")
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "GamOnModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this
                // function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this
                // function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
