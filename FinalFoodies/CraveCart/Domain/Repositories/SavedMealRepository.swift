//
//  SavedMealRepository.swift
//  FinalFoodies / CraveCart
//
//  Protocol for persisting and retrieving saved meals. The SwiftData
//  implementation lives in Data/Repositories; tests use a mock conformer.
//

import Foundation

protocol SavedMealRepository {
    func save(_ meal: MealOption) throws
    func fetchAll() throws -> [MealOption]
    func delete(_ meal: MealOption) throws
}
