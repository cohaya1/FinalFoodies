//
//  FoodiezFeed.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 3/3/22.
//

import Foundation
import SwiftUI

// Define a protocol for URLSession to enable dependency injection for easier testing

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

// Conform URLSession to URLSessionProtocol to be used as a default implementation

extension URLSession: URLSessionProtocol {}

// Define a protocol for API clients to make it possible to create mock API clients for testing


// Create an enum so for diffent methods for http fucntionality to pass around other functions
enum StatusCodes: Error {
    case success
    case notFound
    case serverError
    case networkError
    case badurl
    
    init?(statusCode: Int) {
        switch statusCode {
        case 200: self = .success
        case 404: self = .notFound
        case 500: self = .serverError
        case 401: self = .badurl
        default: return nil
        }
    }

    var description: String {
        switch self {
        case .success: return "Data successfully parsed."
        case .notFound: return "Requested data not found."
        case .serverError: return "Server error occurred."
        case .networkError: return "Network or server is down."
        case .badurl: return "Your Url is incorrect"
        }
    }
}

protocol FetchAPI {
    func getAllRestaurantsService() async throws -> [Restaurant]
    func handleNoInternetConnection()
   
}




// Define a class named "NetworkManager" that adopts the protocols "FetchAPI" and "ObservableObject"
class NetworkManager: FetchAPI, ObservableObject {
    func handleNoInternetConnection() {
        print("No internet connection")
        // Show an alert or a message to the user indicating that there is no internet connection if I had more time I would show an alert for no internet connection
    }
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    // Function to generate the URL for a given page
    func urlForPage(_ page: Int) throws -> URL {
        guard let baseEndpointURL = APIEndpoint.restaurants.url else {
            throw StatusCodes.badurl
        }
        
        var urlComponents = URLComponents(url: baseEndpointURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        
        guard let url = urlComponents?.url else {
            throw StatusCodes.badurl
        }
        
        return url
    }

    // Main data-fetching loop
    func getAllRestaurantsService() async throws -> [Restaurant] {
        var allRestaurants: [Restaurant] = []
        var currentPage = 1
        var isLastPage = false

        while !isLastPage {
            do {
                let url = try urlForPage(currentPage)

                let (data, response) = try await session.data(from: url)
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    // Handle non-200 status codes, possibly breaking out of the loop for certain errors.
                    break
                }

                let decoder = JSONDecoder()
                let restaurants = try decoder.decode([Restaurant].self, from: data)
                
                // If no restaurants are returned, assume it's the last page.
                if restaurants.isEmpty {
                    isLastPage = true
                    break
                }
                
                allRestaurants.append(contentsOf: restaurants)
                currentPage += 1
                
            } catch StatusCodes.badurl {
                print(StatusCodes.badurl.description)
                throw StatusCodes.badurl
            } catch {
                print("Error: \(error.localizedDescription)")
                throw error
            }
        }
        
        return allRestaurants
    }


    }


    
    
//     f
