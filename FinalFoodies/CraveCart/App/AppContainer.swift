//
//  AppContainer.swift
//  FinalFoodies / CraveCart
//
//  Lightweight manual dependency injection. Wires three object graphs:
//
//    Meal generation:
//      ChatGPTService → OpenAIMealGenerationService → DefaultMealRepository
//        → GenerateMealOptionsUseCase
//
//    Saved meals:
//      ModelContext → SwiftDataSavedMealRepository → SaveMealUseCase
//
//    Pantry:
//      ModelContext → SwiftDataPantryRepository → PantryViewModel
//
//  The convenience init() guards against a missing API token — it mirrors
//  AppDelegate's env-var storage so the token is available even on first
//  launch before UIApplicationDelegate fires.
//

import Foundation
import SwiftData

@MainActor
final class AppContainer: ObservableObject {
    let mealRepository: MealRepository
    let generateMealOptionsUseCase: GenerateMealOptionsUseCase
    let estimateSavingsUseCase = EstimateSavingsUseCase()
    let savedMealRepository: SavedMealRepository
    let saveMealUseCase: SaveMealUseCase
    let pantryRepository: PantryRepository

    // Designated init — accepts any ChatGPTServiceProtocol for full testability.
    init(chatGPTService: ChatGPTServiceProtocol) {
        let generationService = OpenAIMealGenerationService(chatGPTService: chatGPTService)
        self.mealRepository = DefaultMealRepository(service: generationService)
        self.generateMealOptionsUseCase = GenerateMealOptionsUseCase(repository: mealRepository)

        let context = Self.makePersistentContext()
        let savedRepo = SwiftDataSavedMealRepository(context: context)
        self.savedMealRepository = savedRepo
        self.saveMealUseCase = SaveMealUseCase(repository: savedRepo)
        self.pantryRepository = SwiftDataPantryRepository(context: context)
    }

    // Convenience init for production: primes Keychain from env var if needed,
    // then uses ChatGPTService when a token exists or falls back to a safe stub.
    convenience init() {
        if let envToken = ProcessInfo.processInfo.environment["OPENAI_API_TOKEN"] {
            TokenManager().storeApiToken(token: envToken)
        }
        let service: ChatGPTServiceProtocol = TokenManager().hasApiToken()
            ? ChatGPTService()
            : NoTokenChatGPTService()
        self.init(chatGPTService: service)
    }

    func makeCravingHomeViewModel() -> CravingHomeViewModel {
        CravingHomeViewModel(
            generateMealOptions: generateMealOptionsUseCase,
            saveMealUseCase: saveMealUseCase,
            pantryRepository: pantryRepository
        )
    }

    func makeSavedMealsViewModel() -> SavedMealsViewModel {
        SavedMealsViewModel(repository: savedMealRepository)
    }

    func makePantryViewModel() -> PantryViewModel {
        PantryViewModel(repository: pantryRepository)
    }

    private static func makePersistentContext() -> ModelContext {
        let schema = Schema([SavedMeal.self, PantryEntry.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        // Crash here is a programmer error (schema mismatch), not a runtime fault.
        let container = try! ModelContainer(for: schema, configurations: config)
        return ModelContext(container)
    }
}

// MARK: - No-token stub

private struct NoTokenChatGPTService: ChatGPTServiceProtocol {
    func generateResponse(for prompt: String) async throws -> String {
        throw CraveCartError.generationFailed(
            "OpenAI API token not found. Add OPENAI_API_TOKEN to your launch environment.")
    }
}
