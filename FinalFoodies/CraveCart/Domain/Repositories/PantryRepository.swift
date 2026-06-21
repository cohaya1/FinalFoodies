//
//  PantryRepository.swift
//  FinalFoodies / CraveCart
//
//  Protocol for CRUD on the user's pantry. SwiftData implementation lives in
//  Data/Repositories; tests use a mock conformer.
//

import Foundation

protocol PantryRepository {
    func add(_ item: PantryItem) throws
    func fetchAll() throws -> [PantryItem]
    func delete(_ item: PantryItem) throws
}
