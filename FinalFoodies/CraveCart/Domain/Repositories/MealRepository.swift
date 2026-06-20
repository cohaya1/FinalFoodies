//
//  MealRepository.swift
//  FinalFoodies / CraveCart
//
//  Abstraction over "where meal options come from". The UseCase depends on
//  this protocol, never on a concrete data source, so the source (remote AI,
//  cache, local templates) can change without touching business logic (DIP).
//

import Foundation

protocol MealRepository {
    func generateMealOptions(request: CravingRequest) async throws -> [MealOption]
}
