//
//  FavouriteGame+CoreDataProperties.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//
//

import Foundation
import CoreData


extension FavouriteGame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteGame> {
        return NSFetchRequest<FavouriteGame>(entityName: "FavouriteGame")
    }

    @NSManaged public var gameID: Int64
    @NSManaged public var imageURL: String?
    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var releaseDate: String?

}

extension FavouriteGame : Identifiable {

}
