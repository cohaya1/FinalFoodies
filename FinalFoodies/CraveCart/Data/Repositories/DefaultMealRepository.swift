//
//  DefaultMealRepository.swift
//  FinalFoodies / CraveCart
//
//  Default MealRepository: asks the generation service for DTOs and maps them
//  into domain models. A caching repository can be layered later without
//  touching the UseCase (the spec's "add cache when needed" note).
//

import Foundation

final class DefaultMealRepository: MealRepository {
    private let service: MealGenerationService
    private let mapper: MealOptionMapper

    init(service: MealGenerationService, mapper: MealOptionMapper = MealOptionMapper()) {
        self.service = service
        self.mapper = mapper
    }

    func generateMealOptions(request: CravingRequest) async throws -> [MealOption] {
        let dtos = try await service.generateMeals(request: request)
        return dtos.map(mapper.map)
    }
}
