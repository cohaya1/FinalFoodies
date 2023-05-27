

import Foundation
import CoreLocation

protocol RestaurantViewModel: ObservableObject, CLLocationManagerDelegate {
    func getAllRestaurants() async
    func search(_ query: String) async
}



class ClosestRestaurantSorter {
    func sort(restaurants: [Restaurant], by userLocation: CLLocation?) async -> [Restaurant] {
        guard let userLocation = userLocation else { return restaurants }

        let geocoder = CLGeocoder()
        var sortedRestaurants: [(restaurant: Restaurant, distance: CLLocationDistance)] = []

        for restaurant in restaurants {
            do {
                let placemarks = try await geocoder.geocodeAddressString(restaurant.restaurantlocation)
                guard let placemark = placemarks.first, let location = placemark.location else {
                    print("No location found for this address: \(restaurant.restaurantlocation)")
                    continue
                }

                let distance = userLocation.distance(from: location)
                sortedRestaurants.append((restaurant, distance))
            } catch {
                print("Geocoding failed for restaurant: \(restaurant.restaurantname), error: \(error)")
            }
        }

        sortedRestaurants.sort { $0.distance < $1.distance }
        sortedRestaurants = Array(sortedRestaurants.prefix(100))
        return sortedRestaurants.map { $0.restaurant }
    }
}

@MainActor
final class RestaurantFetcher: NSObject, RestaurantViewModel, CLLocationManagerDelegate {
    @Published var restaurants: [Restaurant] = []
    @Published var searchResults: [Restaurant] = []
    @Published var userLocation: CLLocation?

    private let restaurantAPI: FetchAPI
    private var restaurantSorter = ClosestRestaurantSorter()
    private let locationManager = CLLocationManager()

    init(using apiMock: FetchAPI = NetworkManager() ){
        self.restaurantAPI = apiMock
        self.restaurantSorter = ClosestRestaurantSorter()
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
        print("User Location: \(location)") // Debug
        userLocation = location
        restaurantSorter = ClosestRestaurantSorter()
        await getAllRestaurants()
    }

    func requestLocationPermission() {
        let status = CLLocationManager.authorizationStatus()

        switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .denied, .restricted:
                // Handle disabled location permissions
                break
            case .authorizedWhenInUse, .authorizedAlways:
                // Permissions are already granted
                break
            @unknown default:
                break
        }
    }

    func getAllRestaurants() async {
        do {
            let fetchedRestaurants = try await restaurantAPI.getAllRestaurantsService()
            restaurants = await restaurantSorter.sort(restaurants: fetchedRestaurants, by: userLocation)
            print("Fetched restaurants: \(restaurants)") // Debug
        } catch {
            print("Error can't return any data: \(error)")
            if error.localizedDescription == "Failure" {
                // service.handleNoInternetConnection() // Uncomment if you have this function in service.
            }
        }
    }

    // Search function
    func search(_ query: String) {
        searchResults = restaurants.filter { $0.restaurantname.contains(query) }
    }
}
