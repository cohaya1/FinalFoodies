//
//  FinalFoodiesApp.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 2/12/22.
//
import Firebase
import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
@main
struct FinalFoodiesApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authVM = AuthViewModel(authenticator: FirebaseAuthenticator())
    @StateObject private var favoritesViewModel = FavoritesViewModel<Restaurant>()  // Adding this line

    var body: some Scene {
        WindowGroup {
            if authVM.userSession != nil {
                TabViewUI() // your main app view
                    .environmentObject(authVM)
                    .environmentObject(favoritesViewModel) // Supplying the ViewModel here
                    .onAppear {
                        authVM.listenToAuthChanges()
                    }
            } else {
                AuthView() // your authentication view
                    .environmentObject(authVM)
                    .onAppear {
                        authVM.listenToAuthChanges()
                    }
            }
        }
    }
}
