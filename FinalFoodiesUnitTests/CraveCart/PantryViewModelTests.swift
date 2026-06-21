//
//  PantryViewModelTests.swift
//  FinalFoodiesUnitTests / CraveCart
//
//  Slice 3 — Pantry. Tests the pantry ViewModel and the flow from
//  pantry items into a CravingRequest.
//

import XCTest
@testable import FinalFoodies

@MainActor
final class PantryViewModelTests: XCTestCase {

    // MARK: - PantryViewModel

    func test_load_populatesItems() {
        let repo = MockPantryRepository()
        repo.items = [PantryItem(name: "eggs"), PantryItem(name: "rice")]
        let vm = PantryViewModel(repository: repo)
        vm.load()
        XCTAssertEqual(vm.items.count, 2)
        XCTAssertNil(vm.errorMessage)
    }

    func test_load_whenRepositoryThrows_setsErrorMessage() {
        let repo = MockPantryRepository()
        repo.shouldThrow = true
        let vm = PantryViewModel(repository: repo)
        vm.load()
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertTrue(vm.items.isEmpty)
    }

    func test_addItem_withNonEmptyName_addsAndClearsInput() {
        let repo = MockPantryRepository()
        let vm = PantryViewModel(repository: repo)
        vm.newItemName = "  olive oil  "
        vm.addItem()
        XCTAssertEqual(repo.items.count, 1)
        XCTAssertEqual(repo.items.first?.name, "olive oil")
        XCTAssertTrue(vm.newItemName.isEmpty)
        XCTAssertNil(vm.errorMessage)
    }

    func test_addItem_withEmptyName_setsErrorMessage() {
        let repo = MockPantryRepository()
        let vm = PantryViewModel(repository: repo)
        vm.newItemName = "   "
        vm.addItem()
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertTrue(repo.items.isEmpty)
    }

    func test_delete_removesAtOffset() {
        let repo = MockPantryRepository()
        repo.items = [PantryItem(name: "butter"), PantryItem(name: "milk")]
        let vm = PantryViewModel(repository: repo)
        vm.load()
        vm.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(vm.items.count, 1)
    }

    // MARK: - Pantry items feed into CravingRequest

    func test_submitCraving_includesPantryItems() async {
        let pantryRepo = MockPantryRepository()
        pantryRepo.items = [PantryItem(name: "eggs"), PantryItem(name: "butter")]
        let generator = CapturingGenerator()
        let vm = CravingHomeViewModel(
            generateMealOptions: generator,
            pantryRepository: pantryRepo
        )
        vm.cravingText = "scrambled eggs"
        await vm.submitCraving()
        XCTAssertEqual(generator.capturedRequest?.pantryItems, ["eggs", "butter"])
    }

    func test_submitCraving_withNoPantryRepo_usesEmptyItems() async {
        let generator = CapturingGenerator()
        let vm = CravingHomeViewModel(generateMealOptions: generator)
        vm.cravingText = "pasta"
        await vm.submitCraving()
        XCTAssertEqual(generator.capturedRequest?.pantryItems, [])
    }
}

// MARK: - Mocks

final class MockPantryRepository: PantryRepository {
    var items: [PantryItem] = []
    var shouldThrow = false

    func add(_ item: PantryItem) throws {
        if shouldThrow { throw CraveCartError.generationFailed("mock error") }
        items.append(PantryItem(id: item.id, name: item.name))
    }

    func fetchAll() throws -> [PantryItem] {
        if shouldThrow { throw CraveCartError.generationFailed("mock error") }
        return items
    }

    func delete(_ item: PantryItem) throws {
        if shouldThrow { throw CraveCartError.generationFailed("mock error") }
        items.removeAll { $0.id == item.id }
    }
}

private final class CapturingGenerator: MealOptionsGenerating {
    var capturedRequest: CravingRequest?
    func execute(request: CravingRequest) async throws -> [MealOption] {
        capturedRequest = request
        return []
    }
}
