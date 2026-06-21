//
//  SwiftDataPantryRepository.swift
//  FinalFoodies / CraveCart
//
//  SwiftData-backed PantryRepository. Accepts a ModelContext so tests can
//  inject an in-memory container (isStoredInMemoryOnly: true).
//

import Foundation
import SwiftData

final class SwiftDataPantryRepository: PantryRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func add(_ item: PantryItem) throws {
        context.insert(PantryEntry(from: item))
        try context.save()
    }

    func fetchAll() throws -> [PantryItem] {
        let descriptor = FetchDescriptor<PantryEntry>(
            sortBy: [SortDescriptor(\.addedAt, order: .reverse)]
        )
        return try context.fetch(descriptor).map { $0.toPantryItem() }
    }

    func delete(_ item: PantryItem) throws {
        let id = item.id
        let descriptor = FetchDescriptor<PantryEntry>(
            predicate: #Predicate { $0.id == id }
        )
        guard let record = try context.fetch(descriptor).first else { return }
        context.delete(record)
        try context.save()
    }
}
