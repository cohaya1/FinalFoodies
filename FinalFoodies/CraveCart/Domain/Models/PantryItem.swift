//
//  PantryItem.swift
//  FinalFoodies / CraveCart
//
//  A single ingredient the user already has at home.
//

import Foundation

struct PantryItem: Identifiable, Equatable {
    let id: UUID
    let name: String

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
