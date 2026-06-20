//
//  SavedMealsViewModel.swift
//  FinalFoodies / CraveCart
//
//  UI state for the Saved Meals screen. Loads and deletes via the repository
//  protocol — no persistence knowledge in this layer.
//

import Foundation

@MainActor
final class SavedMealsViewModel: ObservableObject {
    @Published var meals: [MealOption] = []
    @Published var errorMessage: String?

    private let repository: SavedMealRepository

    init(repository: SavedMealRepository) {
        self.repository = repository
    }

    func load() {
        do {
            meals = try repository.fetchAll()
            errorMessage = nil
        } catch {
            errorMessage = "Failed to load saved meals."
        }
    }

    func delete(at offsets: IndexSet) {
        offsets.forEach { idx in
            guard idx < meals.count else { return }
            try? repository.delete(meals[idx])
        }
        load()
    }
}
