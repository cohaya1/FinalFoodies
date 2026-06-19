//
//  AppContainer.swift
//  FinalFoodies / CraveCart
//
//  Lightweight manual dependency injection. Wires the object graph for the
//  craving → meals slice:
//
//    ChatGPTService → OpenAIMealGenerationService → DefaultMealRepository
//      → GenerateMealOptionsUseCase → CravingHomeViewModel
//
//  The convenience init() guards against a missing API token — it mirrors
//  AppDelegate's env-var storage so the token is available even on first
//  launch before UIApplicationDelegate fires. Without a token a stub service
//  is used; it throws .generationFailed so the ViewModel surfaces a message
//  instead of crashing.
//

import Foundation

@MainActor
final class AppContainer: ObservableObject {
    let mealRepository: MealRepository
    let generateMealOptionsUseCase: GenerateMealOptionsUseCase
    let estimateSavingsUseCase = EstimateSavingsUseCase()

    // Designated init — accepts any ChatGPTServiceProtocol for full testability.
    init(chatGPTService: ChatGPTServiceProtocol) {
        let generationService = OpenAIMealGenerationService(chatGPTService: chatGPTService)
        self.mealRepository = DefaultMealRepository(service: generationService)
        self.generateMealOptionsUseCase = GenerateMealOptionsUseCase(repository: mealRepository)
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
        CravingHomeViewModel(generateMealOptions: generateMealOptionsUseCase)
    }
}

// MARK: - No-token stub

private struct NoTokenChatGPTService: ChatGPTServiceProtocol {
    func generateResponse(for prompt: String) async throws -> String {
        throw CraveCartError.generationFailed(
            "OpenAI API token not found. Add OPENAI_API_TOKEN to your launch environment.")
    }
}
