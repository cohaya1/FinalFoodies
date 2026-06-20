//
//  MealOption.swift
//  FinalFoodies / CraveCart
//
//  One of the three meal "paths" returned for a craving. The domain model
//  is intentionally decoupled from the AI/JSON shape (see MealOptionDTO).
//

import Foundation

/// The three fixed paths every craving result returns (spec rule 1).
enum MealPathType: String, Codable, CaseIterable, Equatable {
    case cookItCheap
    case lazyGrocery
    case pickupAlternative

    var label: String {
        switch self {
        case .cookItCheap: return "Cook It Cheap"
        case .lazyGrocery: return "Lazy Grocery"
        case .pickupAlternative: return "Pickup Alternative"
        }
    }
}

struct MealOption: Identifiable, Equatable {
    let id: UUID
    let pathType: MealPathType
    let title: String
    let estimatedTotalCost: Decimal
    let estimatedCostPerServing: Decimal
    let estimatedSavings: Decimal?
    let timeMinutes: Int
    let ingredients: [String]
    let steps: [String]

    init(
        id: UUID = UUID(),
        pathType: MealPathType,
        title: String,
        estimatedTotalCost: Decimal,
        estimatedCostPerServing: Decimal,
        estimatedSavings: Decimal? = nil,
        timeMinutes: Int,
        ingredients: [String],
        steps: [String]
    ) {
        self.id = id
        self.pathType = pathType
        self.title = title
        self.estimatedTotalCost = estimatedTotalCost
        self.estimatedCostPerServing = estimatedCostPerServing
        self.estimatedSavings = estimatedSavings
        self.timeMinutes = timeMinutes
        self.ingredients = ingredients
        self.steps = steps
    }
}
