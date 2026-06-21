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
    private let saveMealUseCase: SaveMealUseCase?
    private let pantryRepository: PantryRepository?

    init(
        generateMealOptions: MealOptionsGenerating,
        saveMealUseCase: SaveMealUseCase? = nil,
        pantryRepository: PantryRepository? = nil
    ) {
        self.generateMealOptions = generateMealOptions
        self.saveMealUseCase = saveMealUseCase
        self.pantryRepository = pantryRepository
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

        let pantryNames = (try? pantryRepository?.fetchAll())?.map(\.name) ?? []
        let request = CravingRequest(
            text: trimmed,
            budget: Decimal(string: budgetText),
            servings: servings,
            pantryItems: pantryNames
        )

        do {
            mealOptions = try await generateMealOptions.execute(request: request)
        } catch let error as CraveCartError {
            errorMessage = error.userMessage
        } catch {
            errorMessage = CraveCartError.generationFailed(error.localizedDescription).userMessage
        }
    }

    func save(meal: MealOption) {
        do {
            try saveMealUseCase?.execute(meal: meal)
        } catch let error as CraveCartError {
            errorMessage = error.userMessage
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
