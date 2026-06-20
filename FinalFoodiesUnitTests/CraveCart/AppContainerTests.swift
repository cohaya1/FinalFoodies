//
//  AppContainerTests.swift
//  FinalFoodiesUnitTests / CraveCart
//
//  Slice 1 — @main cutover. Tests that AppContainer's injectable init wires
//  the graph correctly, and that the no-token stub surfaces a graceful error
//  via the ViewModel instead of crashing.
//

import XCTest
@testable import FinalFoodies

@MainActor
final class AppContainerTests: XCTestCase {

    func test_withInjectedService_makeCravingHomeViewModel_returnsInitialState() {
        let container = AppContainer(chatGPTService: SuccessfulChatGPTService())
        let vm = container.makeCravingHomeViewModel()
        XCTAssertTrue(vm.cravingText.isEmpty)
        XCTAssertFalse(vm.isLoading)
        XCTAssertTrue(vm.mealOptions.isEmpty)
        XCTAssertNil(vm.errorMessage)
    }

    func test_noTokenService_submittingCraving_surfacesErrorMessage() async {
        let container = AppContainer(chatGPTService: FailingChatGPTService())
        let vm = container.makeCravingHomeViewModel()
        vm.cravingText = "pizza"
        await vm.submitCraving()
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
        XCTAssertTrue(vm.mealOptions.isEmpty)
    }
}

// MARK: - Mocks

private final class SuccessfulChatGPTService: ChatGPTServiceProtocol {
    func generateResponse(for prompt: String) async throws -> String { "[]" }
}

private final class FailingChatGPTService: ChatGPTServiceProtocol {
    func generateResponse(for prompt: String) async throws -> String {
        throw CraveCartError.generationFailed("No token")
    }
}
