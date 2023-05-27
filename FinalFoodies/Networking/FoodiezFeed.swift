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

    // Define an asynchronous function that retrieves all restaurants and returns an array of "Restaurant" objects
    func getAllRestaurantsService() async throws -> [Restaurant]{
        
        
        // Create a guard statement to ensure that the APIConstants baseUrl is a valid URL. If not, throw an "invalidURL" error.
        let getrestaurantendpoint = APIEndpoint.restaurants
        guard let url = getrestaurantendpoint.url else {
            throw StatusCodes.badurl
        }
        
        // Create a URLRequest with the URL and send a network request to retrieve data using URLSession.shared.
        // The retrieved data and response are returned as a tuple.
        
        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  let statusCode = StatusCodes(statusCode: httpResponse.statusCode),
                  statusCode == .success else {
                if let statusCode = StatusCodes(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0) {
                    print(statusCode.description)
                    throw statusCode
                } else {
                    print(StatusCodes.networkError.description)
                    throw StatusCodes.networkError
                }
            }

            let decoder = JSONDecoder()
            let restaurants = try decoder.decode([Restaurant].self, from: data)
           
            return restaurants
        } catch {
            print("Error: \(error.localizedDescription)")
            throw error
        }
    }
}
    
    
//     f
