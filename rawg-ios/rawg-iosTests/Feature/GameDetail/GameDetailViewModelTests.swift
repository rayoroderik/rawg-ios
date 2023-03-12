//
//  GameDetailViewModelTests.swift
//  rawg-iosTests
//
//  Created by Rayo on 12/03/23.
//

import XCTest
import CoreData

@testable import rawg_ios

class GameDetailViewModelTests: XCTestCase {
    
    var viewModel: GameDetailViewModel!
    var mockService: MockGameService!
    var mockCoreDataStack: MockCoreDataStack!
    
    override func setUp() {
        super.setUp()
        viewModel = GameDetailViewModel()
        mockService = MockGameService()
        mockCoreDataStack = MockCoreDataStack(modelName: "rawg_ios")
        viewModel.service = mockService
        viewModel.coreDataStack = mockCoreDataStack
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        mockService = nil
    }
    
    func testGetGameDetailSuccess() {
        // given
        let gameID = 1
        viewModel.setGameID(id: gameID)
        let gameDetail = GameDetailModel(id: gameID, name: "Game 1", released: "2020-01-01", backgroundImage: "", rating: 4.5, addedByStatus: nil, developers: nil, publishers: nil, descriptionRaw: nil)
        mockService.gameDetail = gameDetail
        
        let expectation = XCTestExpectation(description: "Get game detail successful")
        viewModel.didGetData = {
            expectation.fulfill()
        }
        
        // when
        viewModel.getGameDetail()
        
        // then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(viewModel.getGame()?.id, gameID)
        XCTAssertEqual(viewModel.getErrorMessage(), "")
    }
    
    func testGetGameDetailFailure() {
        // given
        let gameID = 1
        viewModel.setGameID(id: gameID)
        mockService.shouldReturnError = true
        
        let expectation = XCTestExpectation(description: "Get game detail failure")
        viewModel.didGetData = {
            expectation.fulfill()
        }
        
        // when
        viewModel.getGameDetail()
        
        // then
        wait(for: [expectation], timeout: 1)
        XCTAssertNil(viewModel.getGame())
        XCTAssertEqual(viewModel.getErrorMessage(), "Terjadi kesalahan, silahkan coba lagi.")
    }
    
    func testCheckFavourite() {
        // given
        let gameID = 1
        viewModel.setGameID(id: gameID)
        let managedContext = mockCoreDataStack.managedContext
        let game = FavouriteGame(context: managedContext)
        game.setValue(gameID, forKey: #keyPath(FavouriteGame.gameID))
        try? managedContext.save()
        
        // when
        let isFavourite = viewModel.checkFavourite()
        
        // then
        XCTAssertTrue(isFavourite)
    }
    
    func testSaveFavourite() {
        // given
        let gameID = 1
        viewModel.setGameID(id: gameID)
        let gameDetail = GameDetailModel(id: gameID, name: "Game 1", released: "2020-01-01", backgroundImage: "", rating: 4.5, addedByStatus: nil, developers: nil, publishers: nil, descriptionRaw: nil)
        mockService.gameDetail = gameDetail
        
        let managedContext = mockCoreDataStack.managedContext
        
        // when
        viewModel.getGameDetail()
        viewModel.saveFavourite()
        
        // then
        let gameFetch: NSFetchRequest<FavouriteGame> = FavouriteGame.fetchRequest()
        let results = try? managedContext.fetch(gameFetch)
        XCTAssertEqual(results?.count, 1)
        XCTAssertEqual(Int(results?.first?.gameID ?? 0), gameID)
        XCTAssertEqual(results?.first?.name, "Game 1")
        XCTAssertEqual(results?.first?.releaseDate, "2020-01-01")
        XCTAssertEqual(results?.first?.imageURL, "")
        XCTAssertEqual(results?.first?.rating, 4.5)
    }
    
    func testRemoveFavourite() {
        // given
        let gameID = 1
        viewModel.setGameID(id: gameID)
        let gameDetail = GameDetailModel(id: gameID, name: "Game 1", released: "2020-01-01", backgroundImage: "", rating: 4.5, addedByStatus: nil, developers: nil, publishers: nil, descriptionRaw: nil)
        mockService.gameDetail = gameDetail
        
        let managedContext = mockCoreDataStack.managedContext
        viewModel.getGameDetail()
        viewModel.saveFavourite()
        
        // when
        viewModel.removeFavourite()
        
        // then
        let gameFetch: NSFetchRequest<FavouriteGame> = FavouriteGame.fetchRequest()
        let results = try? managedContext.fetch(gameFetch)
        XCTAssertEqual(results?.count, 0)
        XCTAssertEqual(Int(results?.first?.gameID ?? 0), 0)
    }
    
    func testGetErrorMessage() {
        // Test when errorMessage is not nil
        viewModel.errorMessage = "Terjadi kesalahan, silahkan coba lagi."
        XCTAssertEqual(viewModel.getErrorMessage(), "Terjadi kesalahan, silahkan coba lagi.")
        
        // Test when errorMessage is nil
        viewModel.errorMessage = nil
        XCTAssertEqual(viewModel.getErrorMessage(), "")
    }
}
