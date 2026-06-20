//
//  EstimateSavingsUseCase.swift
//  FinalFoodies / CraveCart
//
//  "Estimated savings vs delivery" — the number that proves the core value.
//  Pure function, trivially testable, clamped at zero (never show negative
//  savings, spec rule).
//

import Foundation

struct EstimateSavingsUseCase {
    func execute(deliveryEstimate: Decimal, homemadeCost: Decimal) -> Decimal {
        max(deliveryEstimate - homemadeCost, 0)
    }
}
