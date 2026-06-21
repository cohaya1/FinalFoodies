//
//  PantryEntry.swift
//  FinalFoodies / CraveCart
//
//  SwiftData @Model for a persisted pantry ingredient.
//

import Foundation
import SwiftData

@Model
final class PantryEntry {
    @Attribute(.unique) var id: UUID
    var name: String
    var addedAt: Date

    init(from item: PantryItem) {
        self.id = item.id
        self.name = item.name
        self.addedAt = Date()
    }

    func toPantryItem() -> PantryItem {
        PantryItem(id: id, name: name)
    }
}
