//
//  CravingHomeView.swift
//  FinalFoodies / CraveCart
//
//  Screen 1 of the MVP: enter a craving + budget, submit, see results.
//  The view is intentionally "dumb" — it binds to the ViewModel and renders.
//

import SwiftUI

struct CravingHomeView: View {
    @StateObject private var viewModel: CravingHomeViewModel

    init(viewModel: CravingHomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("What are you craving?") {
                    TextField("e.g. spicy chicken tacos", text: $viewModel.cravingText)
                    TextField("Budget (optional)", text: $viewModel.budgetText)
                        .keyboardType(.decimalPad)
                    Stepper("Servings: \(viewModel.servings)", value: $viewModel.servings, in: 1...12)
                }

                Section {
                    Button {
                        Task { await viewModel.submitCraving() }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Find cheap meals")
                        }
                    }
                    .disabled(viewModel.isLoading)
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage).foregroundColor(.red)
                    }
                }

                if !viewModel.mealOptions.isEmpty {
                    Section("Meal options") {
                        MealResultsView(options: viewModel.mealOptions)
                    }
                }
            }
            .navigationTitle("CraveCart")
        }
    }
}
