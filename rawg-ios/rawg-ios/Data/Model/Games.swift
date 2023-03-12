//
//  Games.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import Foundation

struct Games: Codable {
    let id: Int?
    let name: String?
    let released: String?
    let tba: Bool?
    let backgroundImage: String?
    let rating: Double?
    let addedByStatus: AddedByStatus?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case released = "released"
        case tba = "tba"
        case backgroundImage = "background_image"
        case rating = "rating"
        case addedByStatus = "added_by_status"
    }
}
