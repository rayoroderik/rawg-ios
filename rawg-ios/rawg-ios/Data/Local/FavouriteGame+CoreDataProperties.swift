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

    @NSManaged public var id: Int64
    @NSManaged public var imageURL: String?
    @NSManaged public var name: String?
    @NSManaged public var rating: Bool
    @NSManaged public var releaseDate: String?

}

extension FavouriteGame : Identifiable {

}
