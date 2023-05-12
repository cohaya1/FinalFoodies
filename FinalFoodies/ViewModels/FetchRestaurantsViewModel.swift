//
//  FetchRestaurantsViewModel.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 3/13/22.
//

//import Foundation
//
//protocol RestaurantViewModel: ObservableObject, CLLocationManagerDelegate {
//    func getAllRestaurants() async
//}
//
//// create fetcher for view model to pass to view
//@MainActor
//final class RestaurantFetcher: NSObject, RestaurantViewModel  {
//
//    @Published  var closestRestaurants : [Restaurant] = []
//    @Published var userLocation: CLLocation?
//
//    //@Published var isLoading: Bool = false
//    // @Published var errorMessage: String? = nil
//
//    private let service: FetchAPI
//
//
//    init(service: FetchAPI ) {
//        self.service = service
//
//    }// helps with unit testing this class independently. Also helps with injecting services into view models if they are sharing one service
//
//
//    func getAllRestaurants() async {
//            do {
//
//                // Try to fetch the schools data from the API.
//                closestRestaurants = try await service.getAllRestaurants()
//
//            } catch {
//                // If there is an error, print the error message.
//                print("Error can't return any data: \(error)")
//
//                // Check if the error message is "Failure".
//                if error.localizedDescription == "Failure" {
//                    // If it is, call the `handleNoInternetConnection` method on the `service` object.
//                    service.handleNoInternetConnection()
//                }
//
//            }
//
//        }
//    }

import Foundation
import CoreLocation

protocol RestaurantViewModel: ObservableObject, CLLocationManagerDelegate {
    
    func getAllRestaurants() async
    func search(_ query: String) async
}

// Strategy Protocol
protocol RestaurantFetchingStrategy {
    func fetchRestaurants() async throws -> [Restaurant]
    
}

// Fetching strategies
class AllRestaurantsFetchingStrategy: RestaurantFetchingStrategy {
    private let service: FetchAPI
    
    init(service: FetchAPI) {
        self.service = service
    }
    
    func fetchRestaurants() async throws -> [Restaurant] {
        // Try to fetch the restaurants data from the API.
        return try await service.getAllRestaurants()
    }
}

class ClosestRestaurantsFetchingStrategy: RestaurantFetchingStrategy {
    private let service: FetchAPI
    private let userLocation: CLLocation
    
    init(service: FetchAPI, userLocation: CLLocation) {
        self.service = service
        self.userLocation = userLocation
    }
    
    func fetchRestaurants() async throws -> [Restaurant] {
        // Fetch all restaurants.
        let allRestaurants = try await service.getAllRestaurants()
        
        // Calculate the distance from the user's location to each restaurant.
        let userLocationCoordinate = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let sortedRestaurants = allRestaurants.map { restaurant -> (restaurant: Restaurant, distance: CLLocationDistance) in
            let restaurantLocation = CLLocation(latitude: restaurant.restaurantlatitude, longitude: restaurant.restaurantlongitude)
            let distance = userLocationCoordinate.distance(from: restaurantLocation)
            return (restaurant, distance)
        }
        // Sort the restaurants by this distance.
            .sorted { $0.distance < $1.distance }
            .map { $0.restaurant } // After sorting, we don't need the distance anymore, so map the array back to just restaurants.
        
        // Return the sorted list of restaurants.
        return sortedRestaurants
    }
}
// Fetcher for view model
@MainActor
final class RestaurantFetcher: NSObject, RestaurantViewModel, CLLocationManagerDelegate {
    @Published var closestRestaurants: [Restaurant] = []
    @Published var searchResults: [Restaurant] = []
    @Published var userLocation: CLLocation?

    private let service: FetchAPI
    private var strategy: RestaurantFetchingStrategy
    private let locationManager = CLLocationManager()

    init(service: FetchAPI) {
        self.service = service
        self.strategy = AllRestaurantsFetchingStrategy(service: service)
        super.init()
        setupLocationManager()
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    private func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) async {
        guard let location = locations.last else { return }
        userLocation = location
        strategy = ClosestRestaurantsFetchingStrategy(service: service, userLocation: location)
        await getAllRestaurants()
    }

    func getAllRestaurants() async {
        do {
            closestRestaurants = try await strategy.fetchRestaurants()
        } catch {
            print("Error can't return any data: \(error)")
            if error.localizedDescription == "Failure" {
                service.handleNoInternetConnection()
            }
        }
    }

    // Search function
    func search(_ query: String) {
        searchResults = closestRestaurants.filter { $0.restaurantname.contains(query) }
    }
}
