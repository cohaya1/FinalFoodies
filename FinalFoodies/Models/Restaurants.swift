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

struct Restaurant: Identifiable, Hashable, Codable  {
    
    let id: Int
    let createdAt: Int
    let restaurantname, restaurantlocation: String
    let restaurantrating: Double?
    let restaurantdescription: String
    let restaurantstype: String
    let restaurantlatitude: Double?
    let restaurantlongitude: Double?
    let restaurantmenu: String?
    let restaurantphotos: String?
    let restaurantreviews: String?
    let deepLinkURL: String?
    let restaurantimage: Restaurantimage?

    init(_ id: Int, _ createdAt: Int, _ restaurantname: String, _ restaurantlocation: String, _ restaurantrating: Double?, _ restaurantdescription: String, _ restaurantstype: String, _ restaurantlatitude: Double?, _ restaurantlongitude: Double?, _ restaurantmenu: String?, _ restaurantphotos: String, _ restaurantreviews: String?, _ deepLinkURL: String?, _ restaurantimage: Restaurantimage?) {
        self.id = id
        self.createdAt = createdAt
        self.restaurantname = restaurantname
        self.restaurantlocation = restaurantlocation
        self.restaurantrating = restaurantrating
        self.restaurantdescription = restaurantdescription
        self.restaurantstype = restaurantstype
        self.restaurantlatitude = restaurantlatitude
        self.restaurantlongitude = restaurantlongitude
        self.restaurantmenu = restaurantmenu
        self.restaurantphotos = restaurantphotos
        self.restaurantreviews = restaurantreviews
        self.deepLinkURL = deepLinkURL
        self.restaurantimage = restaurantimage
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try values.decode(Int.self, forKey: .id)
        let createdAt = try values.decode(Int.self, forKey: .createdAt)
        let restaurantname = try values.decode(String.self, forKey: .restaurantname)
        let restaurantlocation = try values.decode(String.self, forKey: .restaurantlocation)
        let restaurantrating = try values.decodeIfPresent(Double.self, forKey: .restaurantrating)
        let restaurantdescription = try values.decode(String.self, forKey: .restaurantdescription)
        let restaurantstype = try values.decode(String.self, forKey: .restaurantstype)
        let restaurantlatitude = try values.decodeIfPresent(Double.self, forKey: .restaurantlatitude)
        let restaurantlongitude = try values.decodeIfPresent(Double.self, forKey: .restaurantlongitude)
        let restaurantmenu = try values.decodeIfPresent(String.self, forKey: .restaurantmenu)
        let restaurantphotos = try values.decode(String.self, forKey: .restaurantphotos)
        let restaurantreviews = try values.decodeIfPresent(String.self, forKey: .restaurantreviews)
        let deepLinkURL = try values.decodeIfPresent(String.self, forKey: .deepLinkURL)
        let restaurantimage = try values.decodeIfPresent(Restaurantimage.self, forKey: .restaurantimage)

        self.init(id, createdAt, restaurantname, restaurantlocation, restaurantrating, restaurantdescription, restaurantstype, restaurantlatitude, restaurantlongitude, restaurantmenu, restaurantphotos, restaurantreviews, deepLinkURL, restaurantimage)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case restaurantname = "Restaurantname"
        case restaurantlocation = "Restaurantlocation"
        case restaurantrating = "Restaurantrating"
        case restaurantdescription = "Restaurantdescription"
        case restaurantstype = "restaurantstype"
        case restaurantlatitude = "Restaurantlatitude"
        case restaurantlongitude = "Restaurantlongitude"
        case restaurantmenu = "RestaurantMenu"
        case restaurantphotos = "RestaurantPhotos"
        case restaurantreviews = "RestaurantReviews"
        case deepLinkURL = "DeepLinkURL"
        case restaurantimage = "Restaurantimage"
    }
    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(id, forKey: .id)
            try container.encode(createdAt, forKey: .createdAt)
            try container.encode(restaurantname, forKey: .restaurantname)
            try container.encode(restaurantlocation, forKey: .restaurantlocation)
            try container.encode(restaurantrating, forKey: .restaurantrating)
            try container.encode(restaurantdescription, forKey: .restaurantdescription)
            try container.encode(restaurantstype, forKey: .restaurantstype)
            try container.encode(restaurantlatitude, forKey: .restaurantlatitude)
            try container.encode(restaurantlongitude, forKey: .restaurantlongitude)
            try container.encode(restaurantmenu, forKey: .restaurantmenu)
            try container.encode(restaurantphotos, forKey: .restaurantphotos)
            try container.encode(restaurantreviews, forKey: .restaurantreviews)
            try container.encode(deepLinkURL, forKey: .deepLinkURL)
            try container.encode(restaurantimage, forKey: .restaurantimage)
        }
    }



// MARK: - Restaurantimage
// MARK: - Restaurantimage
struct Restaurantimage: Hashable, Codable, Equatable {
    static func == (lhs: Restaurantimage, rhs: Restaurantimage) -> Bool {
        lhs.path == rhs.path &&
        lhs.name == rhs.name
    }
    
    let path, name: String
    let type: TypeEnum
    let size: Int
    let mime: MIME
    let meta: Meta
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case path, name, type, size, mime, meta, url
    }
}

// MARK: - Meta
struct Meta: Hashable, Codable {
    let width, height: Int
}

enum MIME: String, Codable {
    case imageJPEG = "image/jpeg"
    case imagePNG = "image/png"
}


enum TypeEnum: String, Codable {
    case image = "image"
}



extension Restaurant: Equatable { // in case we want to search for a particular restaurant
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        lhs.restaurantname == rhs.restaurantname &&
        lhs.restaurantlocation == rhs.restaurantlocation &&
        lhs.restaurantimage == rhs.restaurantimage &&
        lhs.restaurantrating == rhs.restaurantrating &&
        lhs.restaurantstype == rhs.restaurantstype
        
    }
    
    
}

extension Restaurant {
    static let sample = Self.init(
        1, // id
        1234567890, // createdAt
        "Restaurant Name", // restaurantname
        "Restaurant Location", // restaurantlocation
        4.5, // restaurantrating
        "Restaurant Description", // restaurantdescription
        "Restaurant Type", // restaurantstype
        40.7128, // restaurantlatitude
        74.0060, // restaurantlongitude
        "Restaurant Menu", // restaurantmenu
        "Restaurant Photos", // restaurantphotos
        "Restaurant Reviews", // restaurantreviews
        "www.deepLinkURL.com", // deepLinkURL
        Restaurantimage(
            path: "path/to/image",
            name: "image_name",
            type: .image,
            size: 1024,
            mime: MIME(rawValue: "image/jpeg")!,
            meta: Meta(width: 800, height: 600),
            url: "www.imageURL.com"
        ) // restaurantimage
    )
}
