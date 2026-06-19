//
//  MealOptionMapperTests.swift
//  FinalFoodiesUnitTests / CraveCart
//
//  DTO → domain mapping, including path-type fallback and Decimal conversion.
//  Costs use exactly-representable values to keep Decimal(Double) deterministic.
//

@testable import FinalFoodies
import XCTest

final class MealOptionMapperTests: XCTestCase {

    private let sut = MealOptionMapper()

    func testMapsAllFields() {
        let dto = MealOptionDTO(
            pathType: "lazyGrocery",
            title: "Sheet-pan Chicken",
            estimatedTotalCost: 12,
            estimatedCostPerServing: 3,
            estimatedSavings: 8,
            timeMinutes: 25,
            ingredients: ["chicken", "potatoes"],
            steps: ["season", "bake"]
        )

        let option = sut.map(dto)

        XCTAssertEqual(option.pathType, .lazyGrocery)
        XCTAssertEqual(option.title, "Sheet-pan Chicken")
        XCTAssertEqual(option.estimatedTotalCost, 12)
        XCTAssertEqual(option.estimatedCostPerServing, 3)
        XCTAssertEqual(option.estimatedSavings, 8)
        XCTAssertEqual(option.timeMinutes, 25)
        XCTAssertEqual(option.ingredients, ["chicken", "potatoes"])
        XCTAssertEqual(option.steps, ["season", "bake"])
    }

    func testUnknownPathTypeFallsBackToCookItCheap() {
        let dto = MealOptionDTO(
            pathType: "somethingNew",
            title: "Mystery",
            estimatedTotalCost: 5,
            estimatedCostPerServing: 5,
            estimatedSavings: nil,
            timeMinutes: 10,
            ingredients: [],
            steps: []
        )

        XCTAssertEqual(sut.map(dto).pathType, .cookItCheap)
    }

    func testNilSavingsMapsToNil() {
        let dto = MealOptionDTO(
            pathType: "pickupAlternative",
            title: "Burrito pickup",
            estimatedTotalCost: 9,
            estimatedCostPerServing: 9,
            estimatedSavings: nil,
            timeMinutes: 15,
            ingredients: [],
            steps: []
        )

        XCTAssertNil(sut.map(dto).estimatedSavings)
    }
}
