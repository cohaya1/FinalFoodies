//
//  CraveCartError.swift
//  FinalFoodies / CraveCart
//
//  Domain-level errors. Anything thrown across the Repository/UseCase
//  boundary is normalised into one of these so the UI never sees raw
//  decoding or networking errors.
//

import Foundation

enum CraveCartError: Error, Equatable {
    /// The generator returned zero usable meal options.
    case emptyMealResults
    /// The AI response could not be produced or parsed. Carries a debug detail.
    case generationFailed(String)
    /// The craving input was empty or otherwise unusable.
    case invalidInput

    /// Message safe to surface directly to the user.
    var userMessage: String {
        switch self {
        case .emptyMealResults:
            return "We couldn't find any meals for that. Try rephrasing your craving."
        case .generationFailed:
            return "Could not create meal ideas right now. Please try again."
        case .invalidInput:
            return "Enter what you are craving to get started."
        }
    }
}
