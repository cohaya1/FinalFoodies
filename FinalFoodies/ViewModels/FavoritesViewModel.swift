//
//  FavoritesViewModel.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 5/19/23.
//

import Combine
import SwiftUI

// Define a protocol for any item that can be identified uniquely
protocol IdentifiableItem {
    var id: Int { get }
}

// Make the Restaurant conform to IdentifiableItem
extension Restaurant: IdentifiableItem {}

// Define a protocol for managing favorite items
protocol FavoritesManaging: ObservableObject where Item: IdentifiableItem {
    associatedtype Item
    var favorites: [Item] { get }
    func addToFavorites(_ item: Item)
    func removeFromFavorites(_ item: Item)
}

// Implement the FavoritesManaging protocol in FavoritesViewModel
class FavoritesViewModel<Item: IdentifiableItem>: FavoritesManaging {
    @Published private(set) var favorites = [Item]()

    func addToFavorites(_ item: Item) {
        if !favorites.contains(where: { $0.id == item.id }) {
            favorites.append(item)
        }
    }

    func removeFromFavorites(_ item: Item) {
        if let index = favorites.firstIndex(where: { $0.id == item.id }) {
            favorites.remove(at: index)
        }
    }
}
