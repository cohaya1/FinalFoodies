//
//  PantryView.swift
//  FinalFoodies / CraveCart
//
//  Screen 4 of the MVP: manage on-hand ingredients that feed into the
//  craving → meal generation prompt to lower estimated costs.
//

import SwiftUI

struct PantryView: View {
    @StateObject private var viewModel: PantryViewModel

    init(viewModel: PantryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("Add ingredient…", text: $viewModel.newItemName)
                            .onSubmit { viewModel.addItem() }
                        Button(action: viewModel.addItem) {
                            Image(systemName: "plus.circle.fill")
                        }
                        .buttonStyle(.borderless)
                    }
                }

                if let error = viewModel.errorMessage {
                    Section {
                        Text(error).foregroundColor(.red)
                    }
                }

                if viewModel.items.isEmpty {
                    Section {
                        Text("No pantry items yet. Add ingredients above.")
                            .foregroundColor(.secondary)
                    }
                } else {
                    Section("In your pantry") {
                        ForEach(viewModel.items) { item in
                            Text(item.name)
                        }
                        .onDelete(perform: viewModel.delete)
                    }
                }
            }
            .navigationTitle("Pantry")
            .onAppear { viewModel.load() }
        }
    }
}
