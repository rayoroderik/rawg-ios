//
//  CoreDataStack.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import Foundation
import CoreData

class CoreDataStack {
    let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
