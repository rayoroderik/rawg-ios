//
//  FavouriteListViewModel.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import CoreData

class FavouriteListViewModel {
    var didGetData: (() -> Void)?
    var updateErrorView: (() -> Void)?
    
    var coreDataStack: CoreDataStack = CoreDataStack(modelName: "rawg_ios")
    var games: [FavouriteGame] = []
    var errorMessage: String?
    
    func getGameList() {
        let gameFetch: NSFetchRequest<FavouriteGame> = FavouriteGame.fetchRequest()
        do {
            let managedContext = coreDataStack.managedContext
            let results = try managedContext.fetch(gameFetch)
            games = results
            didGetData?()
            updateErrorView?()
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            updateErrorView?()
        }
    }
    
    func getListCount() -> Int {
        return games.count
    }
    
    func getGames() -> [FavouriteGame]? {
        return games
    }
    
    func getErrorMessage() -> String {
        return errorMessage ?? ""
    }
}
