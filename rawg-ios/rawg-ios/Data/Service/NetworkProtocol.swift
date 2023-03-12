//
//  NetworkProtocol.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import Foundation

protocol NetworkProtocol {
    
    func request<T: Decodable>(url: URL, method: HTTPMethod,
                               completion: @escaping (Result<T, Error>) -> Void)
}
