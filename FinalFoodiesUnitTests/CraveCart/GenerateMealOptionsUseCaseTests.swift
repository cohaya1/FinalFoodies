//
//  GenerateMealOptionsUseCaseTests.swift
//  FinalFoodiesUnitTests / CraveCart
//
//  Verifies the core action: empty results → error, non-empty → passthrough,
//  underlying errors propagate. Uses a MockMealRepository in the same nested
//  mock style as RestaurantFetcherTests.MockFetchAPI.
//

@testable import FinalFoodies
import XCTest

final class GenerateMealOptionsUseCaseTests: XCTestCase {

    func testReturnsOptionsWhenRepositoryHasResults() async throws {
        let repo = MockMealRepository()
        repo.result = [Self.sampleOption(title: "Chickpea Tacos")]
        let sut = GenerateMealOptionsUseCase(repository: repo)

        let options = try await sut.execute(request: Self.sampleRequest)

        XCTAssertEqual(options.count, 1)
        XCTAssertEqual(options.first?.title, "Chickpea Tacos")
    }

    func testThrowsEmptyMealResultsWhenRepositoryReturnsNothing() async {
        let repo = MockMealRepository()
        repo.result = []
        let sut = GenerateMealOptionsUseCase(repository: repo)

        do {
            _ = try await sut.execute(request: Self.sampleRequest)
            XCTFail("Expected emptyMealResults to be thrown")
        } catch {
            XCTAssertEqual(error as? CraveCartError, .emptyMealResults)
        }
    }

    func testPropagatesRepositoryError() async {
        let repo = MockMealRepository()
        repo.error = CraveCartError.generationFailed("boom")
        let sut = GenerateMealOptionsUseCase(repository: repo)

        do {
            _ = try await sut.execute(request: Self.sampleRequest)
            XCTFail("Expected error to propagate")
        } catch {
            XCTAssertEqual(error as? CraveCartError, .generationFailed("boom"))
        }
    }

    // MARK: - Helpers

    static let sampleRequest = CravingRequest(text: "tacos")

    static func sampleOption(title: String) -> MealOption {
        MealOption(
            pathType: .cookItCheap,
            title: title,
            estimatedTotalCost: 8,
            estimatedCostPerServing: 4,
            estimatedSavings: 10,
            timeMinutes: 20,
            ingredients: ["tortillas"],
            steps: ["cook"]
        )
    }

    final class MockMealRepository: MealRepository {
        var result: [MealOption] = []
        var error: Error?

        func generateMealOptions(request: CravingRequest) async throws -> [MealOption] {
            if let error { throw error }
            return result
        }
    }
}
