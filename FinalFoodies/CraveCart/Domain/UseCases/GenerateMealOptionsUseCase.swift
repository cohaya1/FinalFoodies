//
//  GenerateMealOptionsUseCase.swift
//  FinalFoodies / CraveCart
//
//  The core user action: turn a craving into meal options. ViewModels depend
//  on `MealOptionsGenerating` (the abstraction) so they can be tested with a
//  stub and never know about repositories or networking.
//

import Foundation

protocol MealOptionsGenerating {
    func execute(request: CravingRequest) async throws -> [MealOption]
}

struct GenerateMealOptionsUseCase: MealOptionsGenerating {
    private let repository: MealRepository

    init(repository: MealRepository) {
        self.repository = repository
    }

    func execute(request: CravingRequest) async throws -> [MealOption] {
        let options = try await repository.generateMealOptions(request: request)
        guard !options.isEmpty else {
            throw CraveCartError.emptyMealResults
        }
        return options
    }
}
