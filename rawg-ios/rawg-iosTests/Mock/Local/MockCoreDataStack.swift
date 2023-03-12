//
//  MockCoreDataStack.swift
//  rawg-iosTests
//
//  Created by Rayo on 12/03/23.
//

import CoreData
@testable import rawg_ios

class MockCoreDataStack: CoreDataStack {
    
    override init(modelName: String) {
        super.init(modelName: modelName)
        setupInMemoryPersistentStore()
    }
    
    private func setupInMemoryPersistentStore() {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        storeContainer = container
    }
    
    func reset() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavouriteGame")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func saveFavouriteGame(game: FavouriteGame) {
        let entity = NSEntityDescription.entity(forEntityName: "FavouriteGame", in: managedContext)!
        var favouriteGame = FavouriteGame(entity: entity, insertInto: managedContext)
        favouriteGame = game
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            return
        }
    }
}
