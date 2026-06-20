//
//  CravingHomeViewModelTests.swift
//  FinalFoodiesUnitTests / CraveCart
//
//  ViewModel coordinates state only: empty input → error and no UseCase call;
//  valid input → options populated; thrown error → user message. Injects a
//  stub conforming to MealOptionsGenerating (DIP).
//

@testable import FinalFoodies
import XCTest

@MainActor
final class CravingHomeViewModelTests: XCTestCase {

    func testEmptyCravingShowsErrorAndDoesNotCallUseCase() async {
        let useCase = StubGenerator()
        let sut = CravingHomeViewModel(generateMealOptions: useCase)
        sut.cravingText = "   "

        await sut.submitCraving()

        XCTAssertEqual(sut.errorMessage, CraveCartError.invalidInput.userMessage)
        XCTAssertFalse(useCase.didExecute)
        XCTAssertTrue(sut.mealOptions.isEmpty)
    }

    func testValidCravingPopulatesMealOptions() async {
        let useCase = StubGenerator()
        useCase.result = [Self.option(title: "Budget Stir-fry")]
        let sut = CravingHomeViewModel(generateMealOptions: useCase)
        sut.cravingText = "stir fry"

        await sut.submitCraving()

        XCTAssertTrue(useCase.didExecute)
        XCTAssertEqual(sut.mealOptions.map(\.title), ["Budget Stir-fry"])
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func testThrownErrorSetsUserMessage() async {
        let useCase = StubGenerator()
        useCase.error = CraveCartError.emptyMealResults
        let sut = CravingHomeViewModel(generateMealOptions: useCase)
        sut.cravingText = "tacos"

        await sut.submitCraving()

        XCTAssertEqual(sut.errorMessage, CraveCartError.emptyMealResults.userMessage)
        XCTAssertTrue(sut.mealOptions.isEmpty)
    }

    // MARK: - Helpers

    static func option(title: String) -> MealOption {
        MealOption(
            pathType: .cookItCheap,
            title: title,
            estimatedTotalCost: 6,
            estimatedCostPerServing: 3,
            estimatedSavings: 12,
            timeMinutes: 15,
            ingredients: [],
            steps: []
        )
    }

    final class StubGenerator: MealOptionsGenerating {
        var result: [MealOption] = []
        var error: Error?
        private(set) var didExecute = false

        func execute(request: CravingRequest) async throws -> [MealOption] {
            didExecute = true
            if let error { throw error }
            return result
        }
    }
}
