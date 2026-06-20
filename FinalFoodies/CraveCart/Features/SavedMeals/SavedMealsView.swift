//
//  SavedMealsView.swift
//  FinalFoodies / CraveCart
//
//  Screen 5 of the MVP: saved meal cards with swipe-to-delete.
//

import SwiftUI

struct SavedMealsView: View {
    @StateObject private var viewModel: SavedMealsViewModel

    init(viewModel: SavedMealsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.meals.isEmpty {
                    ContentUnavailableView(
                        "No saved meals",
                        systemImage: "bookmark.slash",
                        description: Text("Save a meal from the CraveCart tab.")
                    )
                } else {
                    List {
                        ForEach(viewModel.meals) { meal in
                            MealCardView(option: meal)
                        }
                        .onDelete(perform: viewModel.delete)
                    }
                }
            }
            .navigationTitle("Saved Meals")
            .onAppear { viewModel.load() }
        }
    }
}
