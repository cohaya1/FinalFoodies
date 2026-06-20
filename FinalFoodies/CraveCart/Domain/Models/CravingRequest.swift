//
//  CravingRequest.swift
//  FinalFoodies / CraveCart
//
//  The single input to the core loop: what the user is craving, plus
//  the constraints that shape the meal options we generate.
//

import Foundation

struct CravingRequest: Equatable {
    let text: String
    let budget: Decimal?
    let servings: Int
    let effortLevel: EffortLevel
    let pantryItems: [String]

    init(
        text: String,
        budget: Decimal? = nil,
        servings: Int = 1,
        effortLevel: EffortLevel = .easy,
        pantryItems: [String] = []
    ) {
        self.text = text
        self.budget = budget
        self.servings = servings
        self.effortLevel = effortLevel
        self.pantryItems = pantryItems
    }
}
