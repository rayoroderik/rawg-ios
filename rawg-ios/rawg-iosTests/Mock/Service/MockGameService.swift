//
//  MockGameService.swift
//  rawg-iosTests
//
//  Created by Rayo on 12/03/23.
//

import Foundation
@testable import rawg_ios

class MockGameService: GameServiceProtocol {
    
    var shouldReturnError = false
    var gameDetail: GameDetailModel? = nil
    
    init(shouldReturnError: Bool = false) {
        self.shouldReturnError = shouldReturnError
    }
    
    func fetchGameList(page: Int, completion: @escaping (Result<GameListResponse, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NetworkError.unknown))
        } else {
            // create a dummy game list response
            let game1 = Games(id: 1, name: "Game 1", released: "2020-01-01", backgroundImage: "", rating: 4.5, addedByStatus: nil)
            let game2 = Games(id: 2, name: "Game 2", released: "2020-01-02", backgroundImage: "", rating: 4.0, addedByStatus: nil)
            let game3 = Games(id: 3, name: "Game 3", released: "2020-01-03", backgroundImage: "", rating: 3.5, addedByStatus: nil)
            let gameListResponse = GameListResponse(count: 3, next: nil, previous: nil, results: [game1, game2, game3])
            completion(.success(gameListResponse))
        }
    }
    
    func searchGame(keyword: String, completion: @escaping (Result<GameListResponse, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NetworkError.unknown))
        } else {
            // create a dummy game list response for search
            let game1 = Games(id: 1, name: "Game 1", released: "2020-01-01", backgroundImage: "", rating: 4.5, addedByStatus: nil)
            let game2 = Games(id: 2, name: "Game 2", released: "2020-01-02", backgroundImage: "", rating: 4.0, addedByStatus: nil)
            let gameListResponse = GameListResponse(count: 2, next: nil, previous: nil, results: [game1, game2])
            completion(.success(gameListResponse))
        }
    }
    
    func fetchGameDetail(gameID: Int, completion: @escaping (Result<GameDetailModel, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NetworkError.unknown))
        } else {
            // create a dummy game detail response
            let developer = Developer(id: 1, name: "Developer 1")
            let publisher = Developer(id: 2, name: "Publisher 1")
            let addedByStatus = AddedByStatus(yet: 10, owned: 20, beaten: 30, toplay: 40, dropped: 50, playing: 60)
            let gameDetailModel = GameDetailModel(id: 1, name: "Game 1", released: "2020-01-01", backgroundImage: "", rating: 4.5, addedByStatus: addedByStatus, developers: [developer], publishers: [publisher], descriptionRaw: "This is a dummy game.")
            completion(.success(gameDetailModel))
        }
    }
}

