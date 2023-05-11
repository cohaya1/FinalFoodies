//
//  UrlComposer.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 5/10/23.
//

import Foundation


// URLComposerProtocol is a protocol that defines the basic properties required for composing a URL.
protocol URLComposerProtocol {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var url: URL? { get }
}

// APIEndpoint is an enumeration that represents different API endpoints.
enum APIEndpoint {
    case restaurants // The endpoint for fetching articles.
}

// APIEndpoint conforms to the URLComposerProtocol, which allows it to provide properties for composing URLs.
extension APIEndpoint: URLComposerProtocol {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "x8ki-letl-twmt.n7.xano.io"
    }

    var path: String {
        switch self {
        case .restaurants:
            
            // The URL path 
            return "/api:zmetZ6cP/restaurants"
        }
    }

    // Computed property that returns a URL object based on the provided properties.
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path

   // Return the composed URL.
        return components.url
    }
}
