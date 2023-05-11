//
//  FoodiesTests.swift
//  FinalFoodiesTests
//
//  Created by Chika Ohaya on 2/18/23.
//
@testable import  FinalFoodies
import XCTest

final class FoodiesTests: XCTestCase {
    class RemoteFeedLoader {
        func load() {
            HTTPClient.shared.requestedURL = URL(string: APIConstants.baseUrl)

        }
    }
    class HTTPClient {
        static let shared = HTTPClient()
        
        private init() {}
        
        var requestedURL: URL?
    }
    func test_init() {
        let client = HTTPClient.shared
        let sut = NetworkManager()
        
        XCTAssertNil(client.requestedURL)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
