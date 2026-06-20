//
//  MealCardView.swift
//  FinalFoodies / CraveCart
//
//  Renders a single meal option: title, path, cost, time, and the savings
//  line that proves the core value ("Estimated savings: $X vs delivery").
//

import SwiftUI

struct MealCardView: View {
    let option: MealOption
    var onSave: (() -> Void)? = nil

    private var costPerServing: String {
        CurrencyFormatter.string(from: option.estimatedCostPerServing)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(option.pathType.label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(option.title)
                .font(.headline)
            HStack(spacing: 12) {
                Label("\(costPerServing)/serving", systemImage: "dollarsign.circle")
                Label("\(option.timeMinutes) min", systemImage: "clock")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)

            if let savings = option.estimatedSavings, savings > 0 {
                Text("Estimated savings: \(CurrencyFormatter.string(from: savings)) vs delivery")
                    .font(.subheadline.bold())
                    .foregroundColor(.green)
            }

            if let onSave {
                Button(action: onSave) {
                    Label("Save meal", systemImage: "bookmark")
                        .font(.subheadline)
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(.vertical, 4)
    }
}

/// Small shared helper so cost rendering stays consistent across the app.
enum CurrencyFormatter {
    static func string(from value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: value as NSDecimalNumber) ?? "$\(value)"
    }
}
