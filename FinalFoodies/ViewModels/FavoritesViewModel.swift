//
//  FavoritesViewModel.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 5/19/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import Combine

// Protocol for uniquely identifiable and codable items
protocol IdentifiableItem: Codable {
    var id: Int { get }
}

// Make sure Restaurant conforms to IdentifiableItem
extension Restaurant: IdentifiableItem {
    // Assume Restaurant has properties like id, name, etc.
}

// Protocol for managing favorite items
protocol FavoritesManaging: ObservableObject {
    associatedtype Item: IdentifiableItem
    var favorites: [Item] { get set }
    func addToFavorites(_ item: Item) async
    func removeFromFavorites(_ item: Item) async
}

// FirebaseManager for Firebase operations
protocol FirebaseManagerProtocol {
    func setUserId(_ newUserId: String?)
    func fetchFavorites<T: IdentifiableItem>() async -> [T]?
    func addFavorite<T: IdentifiableItem>(_ item: T) async -> Bool
    func removeFavorite<T: IdentifiableItem>(_ item: T) async -> Bool
}

class FirebaseManager: FirebaseManagerProtocol {
    private lazy var database = Firestore.firestore()
    private var userId: String?

    init() {
            listenToAuthChanges()
        }
    private func listenToAuthChanges() {
            Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
                self?.userId = user?.uid
                // Do not fetch favorites here; just update userId
            }
        }
    private func ensureFirebaseIsConfigured() -> Bool {
        return FirebaseApp.app() != nil
    }
    func setUserId(_ newUserId: String?) {
        self.userId = newUserId
    }
    
    func fetchFavorites<T: IdentifiableItem>() async -> [T]? {
        guard ensureFirebaseIsConfigured(), let userId = userId else { return nil }
        
        
        
        do {
            let snapshot = try await database.collection("users").document(userId).collection("favorites").getDocuments()
            return snapshot.documents.compactMap { try? $0.data(as: T.self) }
        } catch {
            print("Error fetching documents: \(error)")
            return nil
        }
    }
    
    func addFavorite<T: IdentifiableItem>(_ item: T) async -> Bool {
        guard ensureFirebaseIsConfigured(), let userId = userId else { return false }
        
        do {
            let document = database.collection("users").document(userId).collection("favorites").document("\(item.id)")
            try  document.setData(from: item)
            return true
        } catch {
            print("Error adding favorite: \(error)")
            return false
        }
    }


    
    
    func removeFavorite<T: IdentifiableItem>(_ item: T) async -> Bool {
        guard ensureFirebaseIsConfigured(), let userId = userId else { return false }
        
        do {
            // Removing the favorite item from the user's specific 'favorites' subcollection
            let document = database.collection("users").document(userId).collection("favorites").document("\(item.id)")
            try await document.delete()
            return true
        } catch {
            print("Error removing favorite: \(error)")
            return false
        }
    }
}

// FavoritesViewModel implementing FavoritesManaging
class FavoritesViewModel<Item: IdentifiableItem>: FavoritesManaging {
    
    @Published var favorites = [Item]()
    private var firebaseManager: FirebaseManagerProtocol
    private var cancellables = Set<AnyCancellable>() // Storage for Combine subscriptions

    init(firebaseManager: FirebaseManagerProtocol, authViewModel: AuthViewModel) {
            self.firebaseManager = firebaseManager
            observeAuthChanges(authViewModel: authViewModel)
        }
    private func observeAuthChanges(authViewModel: AuthViewModel) {
        authViewModel.$userSession
            .sink { [weak self] userSession in
                guard let strongSelf = self else { return }

                if let userId = userSession?.uid {
                    strongSelf.firebaseManager.setUserId(userId)
                    Task { [weak self] in
                        await self?.fetchFavorites()
                    }
                } else {
                    strongSelf.clearFavorites()
                }
            }
            .store(in: &cancellables)
    }


    func initializeFavorites() {
            Task {
                await fetchFavorites()
            }
        }

        func fetchFavorites() async {
            if let fetchedFavorites: [Item] = await firebaseManager.fetchFavorites() {
                self.favorites = fetchedFavorites
            }
        }


    func addToFavorites(_ item: Item) async {
        guard !favorites.contains(where: { $0.id == item.id }) else { return }
        let success = await firebaseManager.addFavorite(item)
        if success {
            self.favorites.append(item)
        }
    }

    func removeFromFavorites(_ item: Item) async {
        let success = await firebaseManager.removeFavorite(item)
        if success {
            self.favorites.removeAll { $0.id == item.id }
        }
    }
}
extension FavoritesViewModel {
    func clearFavorites() {
        favorites.removeAll()
    }
}
extension FavoritesViewModel {
    func updateUserId(_ userId: String) {
        guard !userId.isEmpty else {
            print("Error: Attempted to update with an empty userId")
            return
        }
        (firebaseManager as? FirebaseManager)?.setUserId(userId)
        Task {
            await fetchFavorites()
        }
    }
}

