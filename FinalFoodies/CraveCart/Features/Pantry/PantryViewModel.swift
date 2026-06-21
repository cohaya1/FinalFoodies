//
//  PantryViewModel.swift
//  FinalFoodies / CraveCart
//
//  UI state for the Pantry screen. Manages item list, the add-item text field,
//  and deletion. No persistence knowledge — delegates to PantryRepository.
//

import Foundation

@MainActor
final class PantryViewModel: ObservableObject {
    @Published var items: [PantryItem] = []
    @Published var newItemName: String = ""
    @Published var errorMessage: String?

    private let repository: PantryRepository

    init(repository: PantryRepository) {
        self.repository = repository
    }

    func load() {
        do {
            items = try repository.fetchAll()
            errorMessage = nil
        } catch {
            errorMessage = "Failed to load pantry."
        }
    }

    func addItem() {
        let name = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else {
            errorMessage = "Enter an ingredient name."
            return
        }
        do {
            try repository.add(PantryItem(name: name))
            newItemName = ""
            errorMessage = nil
            load()
        } catch {
            errorMessage = "Failed to save item."
        }
    }

    func delete(at offsets: IndexSet) {
        offsets.forEach { idx in
            guard idx < items.count else { return }
            try? repository.delete(items[idx])
        }
        load()
    }
}
