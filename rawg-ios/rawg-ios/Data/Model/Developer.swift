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

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
