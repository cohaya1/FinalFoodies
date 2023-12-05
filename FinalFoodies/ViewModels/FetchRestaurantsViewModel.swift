
import SwiftUI
import Foundation
import CoreLocation

protocol RestaurantViewModel: ObservableObject, CLLocationManagerDelegate {
    func getAllRestaurants() async
    func search(_ query: String) async
}




class GeocodeCacheManager: ObservableObject {
    @AppStorage("geocodeCache") private var storedCacheData: Data?
    
    var cache: [String: CLLocation] {
        get {
            if let data = storedCacheData {
                if let storedCache = try? JSONDecoder().decode([String: [String: Double]].self, from: data) {
                    var geocodeCache: [String: CLLocation] = [:]
                    for (address, coordinates) in storedCache {
                        let location = CLLocation(latitude: coordinates["latitude"] ?? 0, longitude: coordinates["longitude"] ?? 0)
                        geocodeCache[address] = location
                    }
                    return geocodeCache
                }
            }
            return [:]
        }
        set {
            var newStoredCache: [String: [String: Double]] = [:]
            for (address, location) in newValue {
                newStoredCache[address] = ["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude]
            }
            DispatchQueue.main.async {
                if let data = try? JSONEncoder().encode(newStoredCache) {
                    self.storedCacheData = data
                }
            }

        }
    }
}


class ClosestRestaurantSorter {
    private let geocodingDelay: TimeInterval = 1.2  // Delay to avoid rate limits
    private var geocodeCacheManager = GeocodeCacheManager()

    func sort(restaurants: [Restaurant], by userLocation: CLLocation?) async -> [Restaurant] {
        guard let userLocation = userLocation else { return restaurants }

        let geocoder = CLGeocoder()
        var sortedRestaurants: [(restaurant: Restaurant, distance: CLLocationDistance)] = []

        for restaurant in restaurants {
            if let cachedLocation = geocodeCacheManager.cache[restaurant.restaurantlocation] {
                let distance = userLocation.distance(from: cachedLocation)
                sortedRestaurants.append((restaurant, distance))
            } else {
                do {
                    let placemarks = try await geocoder.geocodeAddressString(restaurant.restaurantlocation)
                    try await Task.sleep(nanoseconds: UInt64(geocodingDelay * 1_000_000_000))  // Throttle geocoding requests
                    guard let placemark = placemarks.first, let location = placemark.location else {
                        print("No location found for this address: \(restaurant.restaurantlocation)")
                        continue
                    }
                    
                    geocodeCacheManager.cache[restaurant.restaurantlocation] = location
                    let distance = userLocation.distance(from: location)
                    sortedRestaurants.append((restaurant, distance))
                } catch {
                    print("Geocoding failed for restaurant: \(restaurant.restaurantname), error: \(error)")
                }
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
    @Published var dataFetched = false

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

    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        userLocation = locations.first
        print("User Location: \(userLocation as Any)") // Debug
        Task {
            await getAllRestaurants()
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("Location manager error:", error)
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
        guard !dataFetched else { return }

        do {
            let fetchedRestaurants = try await restaurantAPI.getAllRestaurantsService()
            restaurants = await restaurantSorter.sort(restaurants: fetchedRestaurants, by: userLocation)
            print("Fetched restaurants: \(restaurants)") // Debug
            dataFetched = true
        } catch {
            print("Error can't return any data: \(error)")
            if error.localizedDescription == "Failure" {
                // service.handleNoInternetConnection() // Uncomment if you have this function in service.
            }
        }
    }

    func refresh() async {
        dataFetched = false
        await getAllRestaurants()
    }

    // Search function
    func search(_ query: String) {
        searchResults = restaurants.filter { $0.restaurantname.contains(query) || $0.restaurantstype.contains(query) }
    }
}
