//
//  GameListModel.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import Foundation

struct GameListResponse: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Games]?

    enum CodingKeys: String, CodingKey {
        case count = "count"
        case next = "next"
        case previous = "previous"
        case results = "results"
    }
}
