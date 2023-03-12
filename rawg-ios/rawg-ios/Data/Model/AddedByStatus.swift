//
//  AddedByStatus.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import Foundation

struct AddedByStatus: Codable {
    let yet: Int?
    let owned: Int?
    let beaten: Int?
    let toplay: Int?
    let dropped: Int?
    let playing: Int?

    enum CodingKeys: String, CodingKey {
        case yet = "yet"
        case owned = "owned"
        case beaten = "beaten"
        case toplay = "toplay"
        case dropped = "dropped"
        case playing = "playing"
    }
}
