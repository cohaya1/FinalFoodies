//
//  AppContainer.swift
//  FinalFoodies / CraveCart
//
//  Lightweight manual dependency injection (no DI framework — YAGNI). Wires
//  the object graph for the craving → meals slice:
//
//    ChatGPTService → OpenAIMealGenerationService → DefaultMealRepository
//      → GenerateMealOptionsUseCase → CravingHomeViewModel
//
//  Not yet attached to @main; FinalFoodiesApp still launches the existing
//  restaurant flow. The cutover is a tracked slice in STATUS.md so this pass
//  stays non-breaking. `ChatGPTService()` requires an OPENAI_API_TOKEN in the
//  Keychain, so AppContainer must only be constructed once that exists.
//

import Foundation

@MainActor
final class AppContainer {
    let mealRepository: MealRepository
    let generateMealOptionsUseCase: GenerateMealOptionsUseCase
    let estimateSavingsUseCase = EstimateSavingsUseCase()

    init() {
        let chatGPTService = ChatGPTService()
        let generationService = OpenAIMealGenerationService(chatGPTService: chatGPTService)
        self.mealRepository = DefaultMealRepository(service: generationService)
        self.generateMealOptionsUseCase = GenerateMealOptionsUseCase(repository: mealRepository)
    }

    func makeCravingHomeViewModel() -> CravingHomeViewModel {
        CravingHomeViewModel(generateMealOptions: generateMealOptionsUseCase)
    }
}
