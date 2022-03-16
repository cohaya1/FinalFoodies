//
//  Restaurants.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 3/8/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement
struct Restaurant: Hashable, Decodable {
    
    
    let id: Int
    let createdAt: Int
    let restaurantname, restaurantlocation: String
    let restaurantrating: Double
    let restaurantdescription: String
    let restaurantstypeID: Int
    let deepLinkURL: String?
    let restaurantimage: Restaurantimage
    
    init(_ id:Int,_ createdAt:Int, _ restaurantname:String,_ restaurantlocation: String, _ restaurantrating: Double,_ restaurantdescription: String,_ restaurantstypeID: Int,_ deepLinkURL: String?,_ restaurantimage: Restaurantimage ){
        self.id = id
        self.restaurantname = restaurantname
        self.restaurantlocation = restaurantlocation
        self.restaurantrating = restaurantrating
        self.deepLinkURL = deepLinkURL
        self.restaurantimage = restaurantimage
        self.restaurantdescription = restaurantdescription
        self.restaurantstypeID = restaurantstypeID
        self.createdAt = createdAt
    }
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//
//        self.id = try  values.decode(String.self, forKey: .id)
//        self.createdAt = try values.decode(Int.self, forKey: .createdAt)
//        self.restaurantname = try values.decode(String.self, forKey: .restaurantname)
//        self.restaurantlocation = try values.decode(String.self, forKey: .restaurantlocation)
//        self.restaurantdescription = try values.decode(String.self, forKey: .restaurantdescription)
//        self.restaurantstypeID = try values.decode(Int.self, forKey: .restaurantstypeID)
//        self.restaurantrating = try values.decode(String.self, forKey: .restaurantrating)
//        self.deepLinkURL = try values.decode(String.self, forKey: .deepLinkURL)
//
//        self.restaurantimage = try values.nestedContainer(keyedBy: Restaurantimage.self, forKey: .restaurantimage)
//    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case restaurantname = "Restaurantname"
        case restaurantlocation = "Restaurantlocation"
        case restaurantrating = "Restaurantrating"
        case restaurantdescription = "Restaurantdescription"
        case restaurantstypeID = "restaurantstype_id"
        case deepLinkURL = "DeepLinkURL"
        case restaurantimage = "Restaurantimage"
    }
    
}

// MARK: - Restaurantimage
struct Restaurantimage: Hashable,Decodable, Equatable {
    static func == (lhs: Restaurantimage, rhs: Restaurantimage) -> Bool {
        lhs.path == rhs.path &&
        lhs.name == rhs.name
        
    }
    
    let path, name: String
    let type: TypeEnum
    let size: Int
    let mime: String
    let meta: Meta
    let url: String

}

// MARK: - Meta
struct Meta: Hashable,Decodable {
    let width, height: Int
}

enum MIME: String, Decodable {
    case imageJPEG = "image/jpeg"
}

enum TypeEnum: String, Decodable {
    case image = "image"
}

typealias Welcome = [Restaurant]

extension Restaurant: Equatable { // in case we want to search for a particular restaurant
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        lhs.restaurantname == rhs.restaurantname &&
        lhs.restaurantlocation == rhs.restaurantlocation &&
        lhs.restaurantimage == rhs.restaurantimage &&
        lhs.restaurantrating == rhs.restaurantrating &&
        lhs.restaurantstypeID == rhs.restaurantstypeID
        
    }
    
    
}
