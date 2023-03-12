//
//  GameListViewModelTests.swift
//  rawg-iosTests
//
//  Created by Rayo on 12/03/23.
//

import XCTest
@testable import rawg_ios

class GameListViewModelTests: XCTestCase {
    
    var viewModel: GameListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = GameListViewModel()
        viewModel.service = MockGameService()
        
        viewModel.page = 0
        viewModel.games = []
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testGetGameListSuccess() {
        let expectation = XCTestExpectation(description: "Get game list success")
        
        viewModel.didGetData = {
            XCTAssertEqual(self.viewModel.games.count, 3)
            XCTAssertEqual(self.viewModel.getListCount(), 3)
            expectation.fulfill()
        }
        
        viewModel.getGameList()
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetGameListFailure() {
        let expectation = XCTestExpectation(description: "Get game list failure")
        
        viewModel.updateErrorView = {
            XCTAssertNotNil(self.viewModel.getErrorMessage())
            expectation.fulfill()
        }
        
        // Set the service to always return an error
        viewModel.service = MockGameService(shouldReturnError: true)
        
        viewModel.getGameList()
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSearchGameSuccess() {
        let expectation = XCTestExpectation(description: "Search game success")
        
        viewModel.didGetData = {
            XCTAssertEqual(self.viewModel.games.count, 2)
            XCTAssertEqual(self.viewModel.getListCount(), 2)
            expectation.fulfill()
        }
        
        viewModel.searchGame(keyword: "Assassin's Creed")
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSearchGameFailure() {
        let expectation = XCTestExpectation(description: "Search game failure")
        
        viewModel.didGetData = {
            XCTAssertEqual(self.viewModel.games.count, 0)
            XCTAssertEqual(self.viewModel.getListCount(), 0)
            expectation.fulfill()
        }
        
        // Set the service to always return an error
        viewModel.service = MockGameService(shouldReturnError: true)
        
        viewModel.searchGame(keyword: "invalid keyword")
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    func testGetGames() {
        // Test when games is not empty
        let game1 = Games(id: 1, name: "Game 1", released: "2020-01-01", backgroundImage: "", rating: 4.5, addedByStatus: nil)
        let game2 = Games(id: 2, name: "Game 2", released: "2020-01-02", backgroundImage: "", rating: 4.0, addedByStatus: nil)
        viewModel.games = [game1, game2]
        XCTAssertEqual(viewModel.getGames()?.count, 2)
        
        // Test when games is empty
        viewModel.games = []
        XCTAssertEqual(viewModel.getGames()?.count, 0)
    }
    
    func testGetListCount() {
        let game1 = Games(id: 1, name: "Game 1", released: "2020-01-01", backgroundImage: "", rating: 4.5, addedByStatus: nil)
        let game2 = Games(id: 2, name: "Game 2", released: "2020-01-02", backgroundImage: "", rating: 4.0, addedByStatus: nil)
        viewModel.games = [game1, game2]
        XCTAssertEqual(viewModel.getListCount(), 2)
    }
    
    func testLoadNextPage() {
        let expectation = XCTestExpectation(description: "Load next page")
        
        viewModel.didGetData = {
            XCTAssertEqual(self.viewModel.games.count, 3)
            XCTAssertEqual(self.viewModel.getListCount(), 3)
            expectation.fulfill()
        }
        
        viewModel.service = MockGameService()
        
        // Load the next page
        viewModel.loadNextPage()
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRefresh() {
        let expectation = XCTestExpectation(description: "Refresh game list")
        
        viewModel.didGetData = {
            XCTAssertEqual(self.viewModel.games.count, 3)
            XCTAssertEqual(self.viewModel.getListCount(), 3)
            expectation.fulfill()
        }
        
        // Set the service to return two games for each call
        viewModel.service = MockGameService()
        
        // Load the first page
        viewModel.getGameList()
        
        // Refresh the list
        viewModel.refresh()
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCheckIsSearching() {
        XCTAssertFalse(viewModel.checkIsSearching())
        
        viewModel.searchGame(keyword: "Assassin's Creed")
        
        XCTAssertTrue(viewModel.checkIsSearching())
        
    }
    
    func testEndSearch() {
        viewModel.isSearching = true
        viewModel.endSearch()
        XCTAssertFalse(viewModel.isSearching)
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
