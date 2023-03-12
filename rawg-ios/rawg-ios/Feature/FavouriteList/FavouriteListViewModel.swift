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
    
    var service: GameService = GameService()
    var gameList: GameListResponse?
    var games: [FavouriteGame] = []
    var page = 1
    var errorMessage: String?
    
    func getGameList() {
        let gameFetch: NSFetchRequest<FavouriteGame> = FavouriteGame.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(gameFetch)
            games = results
            didGetData?()
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
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
