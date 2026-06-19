//
//  CravingHomeViewModel.swift
//  FinalFoodies / CraveCart
//
//  UI state for the craving input screen. It coordinates state only — input
//  validation plus a single call into the UseCase. It knows nothing about
//  networking, JSON, or repositories (SRP / DIP).
//

import Foundation

@MainActor
final class CravingHomeViewModel: ObservableObject {
    @Published var cravingText: String = ""
    @Published var budgetText: String = ""
    @Published var servings: Int = 1
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var mealOptions: [MealOption] = []

    private let generateMealOptions: MealOptionsGenerating

    init(generateMealOptions: MealOptionsGenerating) {
        self.generateMealOptions = generateMealOptions
    }

    func submitCraving() async {
        let trimmed = cravingText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = CraveCartError.invalidInput.userMessage
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let request = CravingRequest(
            text: trimmed,
            budget: Decimal(string: budgetText),
            servings: servings
        )

        do {
            mealOptions = try await generateMealOptions.execute(request: request)
        } catch let error as CraveCartError {
            errorMessage = error.userMessage
        } catch {
            errorMessage = CraveCartError.generationFailed(error.localizedDescription).userMessage
        }
    }
}
