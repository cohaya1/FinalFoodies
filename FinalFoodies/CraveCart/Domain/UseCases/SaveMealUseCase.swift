//
//  SaveMealUseCase.swift
//  FinalFoodies / CraveCart
//
//  Single-action use case: persist one MealOption via the repository.
//

import Foundation

struct SaveMealUseCase {
    private let repository: SavedMealRepository

    init(repository: SavedMealRepository) {
        self.repository = repository
    }

    func execute(meal: MealOption) throws {
        try repository.save(meal)
    }
}
