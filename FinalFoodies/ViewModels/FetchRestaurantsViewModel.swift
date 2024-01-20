
import SwiftUI
import Foundation
import CoreLocation
import MapKit
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
    private let geocodingDelay: TimeInterval = 1.2
    private var geocodeCacheManager = GeocodeCacheManager()
    private var lastGeocodeTime = Date(timeIntervalSince1970: 0)

    func sort(restaurants: [Restaurant], by userLocation: CLLocation?) async -> [Restaurant] {
        guard let userLocation = userLocation else { return restaurants }

        let geocoder = CLGeocoder()
        var sortedRestaurants: [(restaurant: Restaurant, distance: CLLocationDistance)] = []

        for restaurant in restaurants {
            let currentLocationName = restaurant.restaurantlocation ?? "Online Only"

            // Skip geocoding for online-only or empty addresses
            if currentLocationName == "Online Only" || currentLocationName.isEmpty {
                continue
            }

            if let cachedLocation = geocodeCacheManager.cache[currentLocationName] {
                let distance = userLocation.distance(from: cachedLocation)
                sortedRestaurants.append((restaurant, distance))
            } else {
                // Throttle geocoding requests
                try? await throttleGeocoding()

                do {
                    let placemarks = try await geocoder.geocodeAddressString(currentLocationName)
                    guard let placemark = placemarks.first, let location = placemark.location else {
                        print("No location found for this address: \(currentLocationName)")
                        continue
                    }

                    geocodeCacheManager.cache[currentLocationName] = location
                    let distance = userLocation.distance(from: location)
                    sortedRestaurants.append((restaurant, distance))
                } catch {
                    print("Geocoding failed for restaurant: \(String(describing: restaurant.restaurantname)), error: \(error)")
                }
            }
        }

        sortedRestaurants.sort { $0.distance < $1.distance }
        return sortedRestaurants.map { $0.restaurant }
    }

    private func throttleGeocoding() async throws {
        let now = Date()
        let timeSinceLastGeocode = now.timeIntervalSince(lastGeocodeTime)
        if timeSinceLastGeocode < geocodingDelay {
            let delayTime = geocodingDelay - timeSinceLastGeocode
            try await Task.sleep(nanoseconds: UInt64(delayTime * 1_000_000_000))
        }
        lastGeocodeTime = Date()
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
    func searchNearby(category: String) async {
            guard let userLocation = userLocation else { return }

            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = category
            searchRequest.region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)

            do {
                let searchResponse = try await MKLocalSearch(request: searchRequest).start()
                let nearbyRestaurants = searchResponse.mapItems.map { mapItem in
                    self.createRestaurant(from: mapItem)
                }

                self.searchResults = nearbyRestaurants
            } catch {
                print("Error searching for nearby restaurants: \(error)")
            }
        }
    private func createRestaurant(from mapItem: MKMapItem) -> Restaurant {
            // Extracting data from MKMapItem and creating a Restaurant object
            // Modify this part based on what data you can extract and what's required
            return Restaurant(
                0, // id - Assuming a dummy value or generate a unique ID
                Int(Date().timeIntervalSince1970), // createdAt - Current timestamp
                mapItem.name ?? "Unknown", // restaurantname
                mapItem.placemark.title ?? "No Location", // restaurantlocation
                nil, // restaurantrating - No data available from MKMapItem
                "Description not available", // restaurantdescription
                "Type not available", // restaurantstype
                mapItem.placemark.coordinate.latitude, // restaurantlatitude
                mapItem.placemark.coordinate.longitude, // restaurantlongitude
                nil, // restaurantmenu - No data available from MKMapItem
                nil, // restaurantphotos - No data available from MKMapItem
                nil, // restaurantreviews - No data available from MKMapItem
                nil, // deepLinkURL - No data available from MKMapItem
                nil  // restaurantimage - No data available from MKMapItem
            )
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
            await restaurantAPI.resetDataFetching() // Reset the network manager's state
            dataFetched = false
            await getAllRestaurants()
        }

    // Search function
    func search(_ query: String) {
        searchResults = restaurants.filter { ($0.restaurantname?.contains(query))!  || $0.restaurantstype.contains(query) }
    }
}
