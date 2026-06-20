//
//  SwiftDataSavedMealRepository.swift
//  FinalFoodies / CraveCart
//
//  SwiftData-backed SavedMealRepository. Accepts a ModelContext so that tests
//  can inject an in-memory container (isStoredInMemoryOnly: true).
//

import Foundation
import SwiftData

final class SwiftDataSavedMealRepository: SavedMealRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func save(_ meal: MealOption) throws {
        let record = SavedMeal(from: meal)
        context.insert(record)
        try context.save()
    }

    func fetchAll() throws -> [MealOption] {
        let descriptor = FetchDescriptor<SavedMeal>(
            sortBy: [SortDescriptor(\.savedAt, order: .reverse)]
        )
        return try context.fetch(descriptor).map { $0.toMealOption() }
    }

    func delete(_ meal: MealOption) throws {
        let id = meal.id
        let descriptor = FetchDescriptor<SavedMeal>(
            predicate: #Predicate { $0.id == id }
        )
        guard let record = try context.fetch(descriptor).first else { return }
        context.delete(record)
        try context.save()
    }
}
