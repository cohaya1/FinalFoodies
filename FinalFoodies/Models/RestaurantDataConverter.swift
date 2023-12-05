//
//  RestaurantDataConverter.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 10/7/23.
//

import Foundation
import CoreData


protocol DataConvertible {
    func convertToEntity(_ item: Restaurant, context: NSManagedObjectContext) -> NSManagedObject?
    func convertToModel(_ entity: NSManagedObject) -> Restaurant?
}

class RestaurantDataConverter: DataConvertible {
    
    func convertToEntity(_ item: Restaurant, context: NSManagedObjectContext) -> NSManagedObject? {
        let entity = RestaurantEntity(context: context)
        entity.id = Int16(item.id)
        entity.createdAt = Int16(item.createdAt)
        entity.restaurantname = item.restaurantname
        entity.restaurantlocation = item.restaurantlocation
        entity.restaurantrating = item.restaurantrating ?? 0.0
        entity.restaurantdescription = item.restaurantdescription
        entity.restaurantstype = item.restaurantstype
        entity.restaurantlatitude = item.restaurantlatitude ?? 0.0
        entity.restaurantlongitude = item.restaurantlongitude ?? 0.0
        entity.restaurantmenu = item.restaurantmenu
        entity.restaurantphotos = item.restaurantphotos
        entity.restaurantreviews = item.restaurantreviews
        entity.deepLinkURL = item.deepLinkURL
        
        if let restaurantImage = item.restaurantimage {
            do {
                let imageData = try JSONEncoder().encode(restaurantImage)
                entity.restaurantimage = imageData
            } catch {
                print("Failed to encode Restaurantimage: \(error)")
            }
        }
        
        return entity
    }
    
    func convertToModel(_ entity: NSManagedObject) -> Restaurant? {
        guard let entity = entity as? RestaurantEntity else { return nil }
        
        var restaurantImage: Restaurantimage? = nil
        if let imageData = entity.restaurantimage {
            do {
                restaurantImage = try JSONDecoder().decode(Restaurantimage.self, from: imageData)
            } catch {
                print("Failed to decode Restaurantimage: \(error)")
            }
        }
        
        return Restaurant(
            Int(entity.id),
            Int(entity.createdAt),
            entity.restaurantname ?? "",
            entity.restaurantlocation ?? "",
            entity.restaurantrating,
            entity.restaurantdescription ?? "",
            entity.restaurantstype ?? "",
            entity.restaurantlatitude,
            entity.restaurantlongitude,
            entity.restaurantmenu,
            entity.restaurantphotos ?? "",
            entity.restaurantreviews,
            entity.deepLinkURL,
            restaurantImage
        )
    }
}
