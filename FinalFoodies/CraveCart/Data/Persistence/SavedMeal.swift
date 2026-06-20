//
//  SavedMeal.swift
//  FinalFoodies / CraveCart
//
//  SwiftData @Model for a persisted meal. Stores Decimal costs as Double to
//  avoid SwiftData transformer edge cases; MealOption conversion is lossless
//  at the two-decimal precision used throughout the app.
//

import Foundation
import SwiftData

@Model
final class SavedMeal {
    @Attribute(.unique) var id: UUID
    var pathTypeRaw: String
    var title: String
    var totalCost: Double
    var costPerServing: Double
    var savings: Double?
    var timeMinutes: Int
    var ingredients: [String]
    var steps: [String]
    var savedAt: Date

    init(from option: MealOption) {
        self.id = option.id
        self.pathTypeRaw = option.pathType.rawValue
        self.title = option.title
        self.totalCost = NSDecimalNumber(decimal: option.estimatedTotalCost).doubleValue
        self.costPerServing = NSDecimalNumber(decimal: option.estimatedCostPerServing).doubleValue
        self.savings = option.estimatedSavings
            .map { NSDecimalNumber(decimal: $0).doubleValue }
        self.timeMinutes = option.timeMinutes
        self.ingredients = option.ingredients
        self.steps = option.steps
        self.savedAt = Date()
    }

    func toMealOption() -> MealOption {
        MealOption(
            id: id,
            pathType: MealPathType(rawValue: pathTypeRaw) ?? .cookItCheap,
            title: title,
            estimatedTotalCost: Decimal(totalCost),
            estimatedCostPerServing: Decimal(costPerServing),
            estimatedSavings: savings.map { Decimal($0) },
            timeMinutes: timeMinutes,
            ingredients: ingredients,
            steps: steps
        )
    }
}
