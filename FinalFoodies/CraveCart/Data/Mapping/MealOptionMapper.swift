//
//  MealOptionMapper.swift
//  FinalFoodies / CraveCart
//
//  Translates the AI wire shape (MealOptionDTO) into the domain MealOption.
//  Unknown path types fall back to `.cookItCheap` so a bad enum string never
//  drops a whole result.
//

import Foundation

struct MealOptionMapper {
    func map(_ dto: MealOptionDTO) -> MealOption {
        MealOption(
            pathType: MealPathType(rawValue: dto.pathType) ?? .cookItCheap,
            title: dto.title,
            estimatedTotalCost: Decimal(dto.estimatedTotalCost),
            estimatedCostPerServing: Decimal(dto.estimatedCostPerServing),
            estimatedSavings: dto.estimatedSavings.map { Decimal($0) },
            timeMinutes: dto.timeMinutes,
            ingredients: dto.ingredients,
            steps: dto.steps
        )
    }
}
