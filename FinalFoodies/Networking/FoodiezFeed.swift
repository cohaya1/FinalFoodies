//
//  FoodiezFeed.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 3/3/22.
//

import Foundation
import SwiftUI

// Define a protocol for URLSession to enable dependency injection for easier testing

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
    func resetDataFetching() async
}
struct PaginationState<T> {
    var currentPage = 1
    var isLastPage = false
    var cache: [Int: [T]] = [:]
    var lastError: Error?
}

actor PageSynchronizer<T> {
    private var state = PaginationState<T>()

    func incrementPage() {
        state.currentPage += 1
    }

    func setIsLastPage(_ value: Bool) {
        state.isLastPage = value
    }

    func updateCache(forPage page: Int, withData data: [T]) {
        state.cache[page] = data
    }

    func getCache(forPage page: Int) -> [T]? {
        return state.cache[page]
    }

    func getCurrentPageAndIsLastPage() -> (Int, Bool) {
        return (state.currentPage, state.isLastPage)
    }

    func getLastError() -> Error? {
        return state.lastError
    }

    func setLastError(_ error: Error?) {
        state.lastError = error
    }
    
    
    func resetPagination() {
        state.currentPage = 1
        state.isLastPage = false
        state.cache.removeAll() // Optionally clear the cache
    }
    // Optional: Add methods for throttling requests, if needed
}


actor Semaphore {
    private var count: Int
    private var waiters: [CheckedContinuation<Void, Never>] = []

    init(count: Int = 0) {
        self.count = count
    }

    func wait() async {
        count -= 1
        if count >= 0 { return }
        await withCheckedContinuation { waiters.append($0) }
    }

    func signal(count: Int = 1) {
        self.count += count
        for _ in 0..<count {
            if waiters.isEmpty { return }
            waiters.removeFirst().resume()
        }
    }
}



// Define a class named "NetworkManager" that adopts the protocols "FetchAPI" and "ObservableObject"
class NetworkManager: FetchAPI, ObservableObject {
    func handleNoInternetConnection() {
        print("No internet connection")
        // Show an alert or a message to the user indicating that there is no internet connection if I had more time I would show an alert for no internet connection
    }
    private let session: URLSessionProtocol
    private let semaphore = Semaphore(count: 10) // Limiting to 10 concurrent requests
    private var cache: [Int: [Restaurant]] = [:]
    private let pageSynchronizer = PageSynchronizer<Restaurant>()

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

            while true {
                do {
                    let (currentPage, isLastPage) = await pageSynchronizer.getCurrentPageAndIsLastPage()


                    if isLastPage { break }
                    if let cachedRestaurants = await pageSynchronizer.getCache(forPage: currentPage) {
                        allRestaurants += cachedRestaurants
                        await pageSynchronizer.incrementPage()
                        continue
                    }



                    await semaphore.wait() // Wait for a free slot

                    let url = try urlForPage(currentPage)
                    let (data, response) = try await session.data(from: url)
                    await semaphore.signal()
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                                          httpResponse.statusCode == 200 else {
                                        await pageSynchronizer.setIsLastPage(true)
                                        break
                                    }
                    let decoder = JSONDecoder()
                    let restaurants = try decoder.decode([Restaurant].self, from: data)
                    
                    if restaurants.isEmpty {
                                   await pageSynchronizer.setIsLastPage(true)
                               } else {
                                   allRestaurants.append(contentsOf: restaurants)
                                   await pageSynchronizer.updateCache(forPage: currentPage, withData: restaurants)
                                   await pageSynchronizer.incrementPage()
                               }
                           
                     // Signal when the task is complete
                    
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
    func resetDataFetching() async {
          await pageSynchronizer.resetPagination()
      }

    }


