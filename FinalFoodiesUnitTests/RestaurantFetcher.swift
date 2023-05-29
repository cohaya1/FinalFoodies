//
//  RestaurantFetcher.swift
//  FinalFoodiesUnitTests
//
//  Created by Chika Ohaya on 5/26/23.
//
@testable import FinalFoodies
import Firebase
import FirebaseAuth
import FirebaseCore
import CoreLocation
import XCTest

final class RestaurantFetcherTests: XCTestCase {
    
    var fetcher: RestaurantFetcher!
    var mockAPI: MockFetchAPI!
    var restaurantSorter: ClosestRestaurantSorter!
    
    override func setUpWithError() throws {
        super.setUp()
        mockAPI = MockFetchAPI()
        fetcher = RestaurantFetcher(using: mockAPI)
        restaurantSorter = ClosestRestaurantSorter()
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
        mockAPI = nil
        fetcher = nil
        restaurantSorter = nil
    }
    
    func testGetAllRestaurants() async {
        // Arrange
        mockAPI.restaurants = [Restaurant(restaurantname: "Test Restaurant", restaurantlocation: "8980 Presidential Pkwy Suite 306, Atlanta, GA 30340"),Restaurant(restaurantname: "Test Restaurant2", restaurantlocation: "1210 Tree Summit Pkwy, Duluth, GA 30096")]
        
        // Act
        await fetcher.getAllRestaurants()
        
        // Assert
        XCTAssertEqual(fetcher.restaurants.count, 2)
        XCTAssertEqual(fetcher.restaurants.first?.restaurantname, "Test Restaurant")
        XCTAssertEqual(fetcher.restaurants.first?.restaurantlocation, "8980 Presidential Pkwy Suite 306, Atlanta, GA 30340")
    }
    
    func testSearchRestaurant() async {
        // Arrange
        mockAPI.restaurants = [Restaurant(restaurantname: "Test Restaurant", restaurantlocation: "Test Location")]
        await fetcher.getAllRestaurants()
        
        // Act
        fetcher.search("Test")
        
        // Assert
        XCTAssertEqual(fetcher.searchResults.count, 1)
        XCTAssertEqual(fetcher.searchResults.first?.restaurantname, "Test Restaurant")
    }
    
    func testSortRestaurantsByDistance() async {
        // Arrange
        let userLocation = CLLocation(latitude: 33.9888568, longitude: -84.1669992)
        mockAPI.restaurants = [
            Restaurant(restaurantname: "Restaurant 1", restaurantlocation: "8980 Presidential Pkwy Suite 306, Atlanta, GA 30340"),
            Restaurant(restaurantname: "Restaurant 2", restaurantlocation: "1210 Tree Summit Pkwy, Duluth, GA 30096"),
            Restaurant(restaurantname: "Restaurant 3", restaurantlocation: "140 Orchard Park drive, McDonough, GA 30253")
        ]
        await fetcher.getAllRestaurants()
        
        // Act
        fetcher.restaurants = await restaurantSorter.sort(restaurants: fetcher.restaurants, by: userLocation)
        
        // Assert
        XCTAssertEqual(fetcher.restaurants.first?.restaurantname, "Restaurant 1") // This will cause the test to fail
    }
    
    
    class MockFetchAPI: FetchAPI {
        enum MockAPIError: Error {
            case fakeError
        }
        
        var restaurants: [Restaurant]?
        var error: Error?
        
        func getAllRestaurantsService() async throws -> [Restaurant] {
            if let error = error {
                throw error
            }
            
            if let restaurants = restaurants {
                return restaurants
            }
            
            throw MockAPIError.fakeError
        }
    }
}
