//
//  GameDetailViewModel.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import CoreData

class GameDetailViewModel {
    var didGetData: (() -> Void)?
    
    var service: GameService = GameService()
    
    var gameID: Int?
    var game: GameDetailModel?
    
    var errorMessage: String?
    
    func setGameID(id: Int) {
        gameID = id
    }
    
    func getGameDetail() {
        guard let gameID = gameID else { return }
        service.fetchGameDetail(gameID: gameID) { [weak self] result in
            switch result {
            case .success(let gameDetail):
                guard let self = self else { return }
                self.game = gameDetail
                self.didGetData?()
            case .failure:
                guard let self = self else { return }
                self.errorMessage = "Terjadi kesalahan, silahkan coba lagi."
                self.didGetData?()
            }
        }
    }
    
    func getGame() -> GameDetailModel? {
        return game
    }
    
    func checkFavourite() -> Bool {
        guard let gameID = gameID else { return false }
        let gameFetch: NSFetchRequest<FavouriteGame> = FavouriteGame.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(gameFetch)
            let games = results.map { Int($0.gameID) }
            if games.contains(gameID) {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func saveFavourite() {
        guard let game = game else { return }
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let newGame = FavouriteGame(context: managedContext)
        newGame.setValue(game.id, forKey: #keyPath(FavouriteGame.gameID))
        newGame.setValue(game.backgroundImage, forKey: #keyPath(FavouriteGame.imageURL))
        newGame.setValue(game.name, forKey: #keyPath(FavouriteGame.name))
        newGame.setValue(game.released, forKey: #keyPath(FavouriteGame.releaseDate))
        newGame.setValue(game.rating, forKey: #keyPath(FavouriteGame.rating))
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
    
    func removeFavourite() {
        guard let gameID = gameID else { return }
        let gameFetch: NSFetchRequest<FavouriteGame> = FavouriteGame.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(gameFetch)
            guard let game = results.first(where: { Int($0.gameID) == gameID }) else { return }
            AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(game)
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        } catch {
            return
        }
    }
    
    func getErrorMessage() -> String? {
        return errorMessage
    }
}
