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

final class RestaurantFetcher: XCTestCase {
    
    var fetcher: RestaurantFetcher!
    var mockAPI: MockFetchAPI!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
                mockAPI = MockFetchAPI()
                fetcher = RestaurantFetcher(using: mockAPI)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetAllRestaurants() async {
            // Arrange
            mockAPI.restaurants = [Restaurant(restaurantname: "Test Restaurant", restaurantlocation: "3781 Presidential Pkwy Suite 306, Atlanta, GA 30340"),Restaurant(restaurantname: "Test Restaurant2", restaurantlocation: "1210 Tree Summit Pkwy, Duluth, GA 30096")]

            // Act
            await fetcher.getAllRestaurants()

            // Assert
            XCTAssertEqual(fetcher.restaurants.count, 1)
            XCTAssertEqual(fetcher.restaurants.first?.restaurantname, "Test Restaurant")
            XCTAssertEqual(fetcher.restaurants.first?.restaurantlocation, "Test Location")
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
    }

class MockFetchAPI: FetchAPI {
    enum MockAPIError: Error {
        case fakeError
    }
    
    // You can specify the results you want to return for specific tests.
    var restaurants: [Restaurant]?
    var error: Error?

    func getAllRestaurantsService() async throws -> [Restaurant] {
        // If there's an error set, throw it
        if let error = error {
            throw error
        }

        // If restaurants are set, return them
        if let restaurants = restaurants {
            return restaurants
        }
        
        // Otherwise, throw an unexpected call error, or return a default value
        throw MockAPIError.fakeError
    }
}
