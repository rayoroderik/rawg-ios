//
//  GameService.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import Foundation

protocol GameServiceProtocol {
    typealias CompletionHandler<T> = (Result<T, Error>) -> Void
    
    func fetchGameList(page: Int, completion: @escaping CompletionHandler<GameListResponse>)
    func fetchGameDetail(gameID: Int, completion: @escaping CompletionHandler<GameDetailModel>)
    func searchGame(keyword: String, completion: @escaping CompletionHandler<GameListResponse>)
}

class GameService: GameServiceProtocol {
    typealias CompletionHandler<T> = (Result<T, Error>) -> Void
    
    var apiKey: String { return "7a0c9315a11b41428b24563ccbc521ed" }
    
    var baseURL: URL {
        URL(string: "https://api.rawg.io/api")!
    }
    
    private let network: NetworkProtocol
    
    init(network: NetworkProtocol = NetworkLayer()) {
        self.network = network
    }
    
    func fetchGameList(page: Int, completion: @escaping CompletionHandler<GameListResponse>) {
        var components = URLComponents(url: baseURL.appendingPathComponent("games"),
                                       resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "key", value: apiKey),
                                 URLQueryItem(name: "page", value: "\(page)"),
                                 URLQueryItem(name: "page_size", value: "10")]
        guard let url = components.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        network.request(url: url, method: .get) { (result: Result<GameListResponse, Error>) in
            switch result {
            case .success(let gameList):
                completion(.success(gameList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchGameDetail(gameID: Int, completion: @escaping CompletionHandler<GameDetailModel>) {
        var components = URLComponents(url: baseURL.appendingPathComponent("games/\(gameID)"),
                                       resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "key", value: apiKey)]
        guard let url = components.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        network.request(url: url, method: .get) { (result: Result<GameDetailModel, Error>) in
            switch result {
            case .success(let game):
                completion(.success(game))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchGame(keyword: String, completion: @escaping CompletionHandler<GameListResponse>) {
        var components = URLComponents(url: baseURL.appendingPathComponent("games"),
                                       resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "key", value: apiKey),
                                 URLQueryItem(name: "search", value: keyword),
                                 URLQueryItem(name: "page_size", value: "10")]
        guard let url = components.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        network.request(url: url, method: .get) { (result: Result<GameListResponse, Error>) in
            switch result {
            case .success(let news):
                completion(.success(news))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
