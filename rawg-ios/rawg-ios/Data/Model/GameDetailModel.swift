//
//  GameDetailModel.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import Foundation

struct GameDetailModel: Codable {
    let id: Int?
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let addedByStatus: AddedByStatus?
    let developers: [Developer]?
    let publishers: [Developer]?
    let descriptionRaw: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case released = "released"
        case backgroundImage = "background_image"
        case rating = "rating"
        case addedByStatus = "added_by_status"
        case developers = "developers"
        case publishers = "publishers"
        case descriptionRaw = "description_raw"
    }
}
