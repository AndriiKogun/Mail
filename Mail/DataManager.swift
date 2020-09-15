//
//  DataManager.swift
//  Mail
//
//  Created by A K on 11/9/19.
//  Copyright © 2019 AK. All rights reserved.
//

import UIKit
import CoreData

class DataManager {

    static let shared = DataManager()
    
    func saveUser(email: String, password: String) {
        let managedContext = persistentContainer.viewContext
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedContext) as! User
        user.email = email
        user.password = password
        saveContext()
    }
        
    func user() -> User? {
        return try? persistentContainer.viewContext.fetch(User.fetchRequest()).first as? User
    }
        
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Mail")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                print(error.userInfo)
            }
        }
    }
}
