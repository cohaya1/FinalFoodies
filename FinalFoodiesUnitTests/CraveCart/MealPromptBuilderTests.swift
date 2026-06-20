//
//  MealPromptBuilderTests.swift
//  FinalFoodiesUnitTests / CraveCart
//
//  The prompt must carry the craving, budget, servings, and pantry context
//  so the AI has everything it needs.
//

@testable import FinalFoodies
import XCTest

final class MealPromptBuilderTests: XCTestCase {

    private let sut = MealPromptBuilder()

    func testPromptContainsCravingBudgetAndServings() {
        let request = CravingRequest(
            text: "spicy ramen",
            budget: 15,
            servings: 2
        )

        let prompt = sut.build(for: request)

        XCTAssertTrue(prompt.contains("spicy ramen"))
        XCTAssertTrue(prompt.contains("15"))
        XCTAssertTrue(prompt.contains("Servings: 2"))
        XCTAssertTrue(prompt.contains("cookItCheap"))
    }

    func testPromptMentionsPantryItemsWhenPresent() {
        let request = CravingRequest(text: "pasta", pantryItems: ["garlic", "olive oil"])

        let prompt = sut.build(for: request)

        XCTAssertTrue(prompt.contains("garlic"))
        XCTAssertTrue(prompt.contains("olive oil"))
    }
}
