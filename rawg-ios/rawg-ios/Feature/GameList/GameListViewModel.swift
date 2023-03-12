//
//  GameListViewModel.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import Foundation

class GameListViewModel {
    var didGetData: (() -> Void)?
    var updateErrorView: (() -> Void)?
    
    var service: GameService = GameService()
    var gameList: GameListResponse?
    var games: [Games] = []
    var page: Int = 1
    var errorMessage: String?
    var isSearching: Bool = false
    
    func getGameList() {
        service.fetchGameList(page: page) { [weak self] result in
            switch result {
            case .success(let gameList):
                guard let self = self else { return }
                self.gameList = gameList
                self.games += gameList.results ?? []
                self.errorMessage = nil
                self.didGetData?()
                self.updateErrorView?()
            case .failure:
                guard let self = self else { return }
                self.errorMessage = "Terjadi kesalahan, silahkan coba lagi."
                self.updateErrorView?()
            }
        }
    }
    
    func searchGame(keyword: String) {
        games = []
        service.searchGame(keyword: keyword) { [weak self] result in
            switch result {
            case .success(let gameList):
                guard let self = self else { return }
                self.isSearching = true
                self.gameList = gameList
                self.games += gameList.results ?? []
                self.errorMessage = nil
                self.didGetData?()
                self.updateErrorView?()
            case .failure:
                guard let self = self else { return }
                self.isSearching = false
                self.didGetData?()
            }
        }
    }
    
    func getListCount() -> Int {
        return games.count
    }
    
    func getGames() -> [Games]? {
        return games
    }
    
    func loadNextPage() {
        guard !isSearching else { return }
        page += 1
        
        getGameList()
    }
    
    func refresh() {
        guard !isSearching else { return }
        
        page = 1
        games = []
        getGameList()
    }
    
    func checkIsSearching() -> Bool {
        return isSearching
    }
    
    func endSearch() {
        isSearching = false
    }
    
    func getErrorMessage() -> String {
        return errorMessage ?? ""
    }
}
