//
//  SavedMealsViewModelTests.swift
//  FinalFoodiesUnitTests / CraveCart
//
//  Slice 2 — saved meals. Tests the saved meals list ViewModel.
//

import XCTest
@testable import FinalFoodies

@MainActor
final class SavedMealsViewModelTests: XCTestCase {

    func test_load_populatesMeals() {
        let repo = MockSavedMealRepository()
        repo.savedMeals = [.fixture(), .fixture()]
        let vm = SavedMealsViewModel(repository: repo)
        vm.load()
        XCTAssertEqual(vm.meals.count, 2)
        XCTAssertNil(vm.errorMessage)
    }

    func test_load_whenRepositoryThrows_setsErrorMessage() {
        let repo = MockSavedMealRepository()
        repo.shouldThrow = true
        let vm = SavedMealsViewModel(repository: repo)
        vm.load()
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertTrue(vm.meals.isEmpty)
    }

    func test_delete_removesAtOffset() {
        let repo = MockSavedMealRepository()
        let first = MealOption.fixture(title: "First")
        let second = MealOption.fixture(title: "Second")
        repo.savedMeals = [first, second]
        let vm = SavedMealsViewModel(repository: repo)
        vm.load()
        vm.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(vm.meals.count, 1)
        XCTAssertEqual(vm.meals.first?.title, "Second")
    }

    func test_cravingHomeViewModel_save_callsUseCase() throws {
        let repo = MockSavedMealRepository()
        let useCase = SaveMealUseCase(repository: repo)
        let generateStub = AlwaysSucceedingGenerator()
        let vm = CravingHomeViewModel(
            generateMealOptions: generateStub,
            saveMealUseCase: useCase
        )
        let meal = MealOption.fixture()
        vm.save(meal: meal)
        XCTAssertEqual(repo.savedMeals.count, 1)
    }
}

// MARK: - Mocks

private final class AlwaysSucceedingGenerator: MealOptionsGenerating {
    func execute(request: CravingRequest) async throws -> [MealOption] { [] }
}

// MARK: - Fixtures

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
