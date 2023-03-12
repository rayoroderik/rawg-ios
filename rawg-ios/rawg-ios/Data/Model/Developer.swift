//
//  Developer.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import Foundation

struct Developer: Codable {
    let id: Int?
    let name: String?
    let slug: String?
    let gamesCount: Int?
    let imageBackground: String?
    let domain: String?
    let language: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case slug = "slug"
        case gamesCount = "games_count"
        case imageBackground = "image_background"
        case domain = "domain"
        case language = "language"
    }
}
