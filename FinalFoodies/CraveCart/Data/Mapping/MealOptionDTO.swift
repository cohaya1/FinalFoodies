//
//  MealOptionDTO.swift
//  FinalFoodies / CraveCart
//
//  Wire shape returned by the AI. Kept separate from the domain `MealOption`
//  so a change in the JSON contract never ripples into the app (DTO Mapper
//  pattern). Uses Double for costs because JSON has no Decimal type.
//

import Foundation

struct MealOptionDTO: Decodable, Equatable {
    let pathType: String
    let title: String
    let estimatedTotalCost: Double
    let estimatedCostPerServing: Double
    let estimatedSavings: Double?
    let timeMinutes: Int
    let ingredients: [String]
    let steps: [String]
}
