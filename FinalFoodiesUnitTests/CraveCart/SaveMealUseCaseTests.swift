//
//  SaveMealUseCaseTests.swift
//  FinalFoodiesUnitTests / CraveCart
//
//  Slice 2 — saved meals. Tests the use case and the repository protocol
//  contract via a mock.
//

import XCTest
@testable import FinalFoodies

final class SaveMealUseCaseTests: XCTestCase {

    func test_execute_delegatesToRepository() throws {
        let repo = MockSavedMealRepository()
        let useCase = SaveMealUseCase(repository: repo)
        let meal = MealOption.fixture()
        try useCase.execute(meal: meal)
        XCTAssertEqual(repo.savedMeals.count, 1)
        XCTAssertEqual(repo.savedMeals.first?.id, meal.id)
    }

    func test_execute_propagatesRepositoryError() {
        let repo = MockSavedMealRepository()
        repo.shouldThrow = true
        let useCase = SaveMealUseCase(repository: repo)
        XCTAssertThrowsError(try useCase.execute(meal: .fixture()))
    }

    func test_fetchAll_returnsAllSavedMeals() throws {
        let repo = MockSavedMealRepository()
        let a = MealOption.fixture(title: "A")
        let b = MealOption.fixture(title: "B")
        repo.savedMeals = [a, b]
        XCTAssertEqual(try repo.fetchAll().count, 2)
    }

    func test_delete_removesMatchingMeal() throws {
        let repo = MockSavedMealRepository()
        let meal = MealOption.fixture()
        repo.savedMeals = [meal]
        try repo.delete(meal)
        XCTAssertTrue(repo.savedMeals.isEmpty)
    }
}

// MARK: - Shared mock (also used by SavedMealsViewModelTests)

final class MockSavedMealRepository: SavedMealRepository {
    var savedMeals: [MealOption] = []
    var shouldThrow = false

    func save(_ meal: MealOption) throws {
        if shouldThrow { throw CraveCartError.generationFailed("mock error") }
        savedMeals.append(meal)
    }

    func fetchAll() throws -> [MealOption] {
        if shouldThrow { throw CraveCartError.generationFailed("mock error") }
        return savedMeals
    }

    func delete(_ meal: MealOption) throws {
        if shouldThrow { throw CraveCartError.generationFailed("mock error") }
        savedMeals.removeAll { $0.id == meal.id }
    }
}

// MARK: - Fixture

private extension MealOption {
    static func fixture(
        id: UUID = UUID(),
        title: String = "Test Meal",
        pathType: MealPathType = .cookItCheap
    ) -> MealOption {
        MealOption(
            id: id,
            pathType: pathType,
            title: title,
            estimatedTotalCost: 10,
            estimatedCostPerServing: 5,
            estimatedSavings: 3,
            timeMinutes: 30,
            ingredients: ["eggs"],
            steps: ["cook"]
        )
    }
}
