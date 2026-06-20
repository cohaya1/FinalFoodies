//
//  EffortLevel.swift
//  FinalFoodies / CraveCart
//
//  How much work the user is willing to put into a meal.
//

import Foundation

enum EffortLevel: String, Codable, CaseIterable, Equatable {
    case easy
    case medium
    case involved

    /// Human-readable label for UI and prompts.
    var label: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .involved: return "Involved"
        }
    }
}
