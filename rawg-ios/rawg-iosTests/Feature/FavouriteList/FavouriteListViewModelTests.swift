//
//  FavouriteListViewModelTests.swift
//  rawg-iosTests
//
//  Created by Rayo on 12/03/23.
//

import XCTest
import CoreData
@testable import rawg_ios

class FavouriteListViewModelTests: XCTestCase {
    
    var viewModel: FavouriteListViewModel!
    var mockCoreDataStack: MockCoreDataStack!
    var mockFavouriteGames: [FavouriteGame]!
    
    override func setUp() {
        super.setUp()
        
        viewModel = FavouriteListViewModel()
        mockCoreDataStack = MockCoreDataStack(modelName: "rawg_ios")
        viewModel.coreDataStack = mockCoreDataStack
        
        // Create some mock data
        mockFavouriteGames = [mockFavouriteGame(), mockFavouriteGame(), mockFavouriteGame()]
        
    }
    
    override func tearDown() {
        super.tearDown()
        
//        mockCoreDataStack.reset()
        viewModel = nil
        mockCoreDataStack = nil
        mockFavouriteGames = nil
    }
    
    func testGetGameList() {
        viewModel.getGameList()
        XCTAssertEqual(viewModel.getListCount(), mockFavouriteGames.count)
        print("buset \(mockFavouriteGames.count)")
    }
    
    func testGetGames() {
        viewModel.getGameList()
        let games = viewModel.getGames()
        XCTAssertEqual(games?.count, mockFavouriteGames.count)
        XCTAssertEqual(games?.first?.name, mockFavouriteGames.first?.name)
        XCTAssertEqual(games?.first?.rating, mockFavouriteGames.first?.rating)
        XCTAssertEqual(games?.first?.releaseDate, mockFavouriteGames.first?.releaseDate)
        XCTAssertEqual(games?.first?.gameID, mockFavouriteGames.first?.gameID)
        XCTAssertEqual(games?.first?.imageURL, mockFavouriteGames.first?.imageURL)
    }
    
    func testGetErrorMessage() {
        let errorMessage = "An error occurred"
        viewModel.errorMessage = errorMessage
        XCTAssertEqual(viewModel.getErrorMessage(), errorMessage)
    }
    
    func mockFavouriteGame() -> FavouriteGame {
        let game = FavouriteGame(context: mockCoreDataStack.managedContext)
        game.name = "Mock Game"
        game.rating = 4.5
        game.releaseDate = "2022-01-01"
        game.gameID = 1
        game.imageURL = "https://mockimage.com"
        return game
    }
}
