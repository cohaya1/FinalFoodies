//
//  FinalFoodiesApp.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 2/12/22.
//
import Firebase
import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      if let apiToken = ProcessInfo.processInfo.environment["OPENAI_API_TOKEN"] {
                 let tokenManager = TokenManager()
                 tokenManager.storeApiToken(token: apiToken)
             }
    return true
  }
}
@main
struct FinalFoodiesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authVM: AuthViewModel
    @StateObject var networkStatusViewModel = NetworkStatusViewModel()


    // The favoritesViewModel should not be initialized here as it needs the user ID
    @StateObject private var favoritesViewModel: FavoritesViewModel<Restaurant>



    init() {
            FirebaseApp.configure()
            
            let firebaseManager = FirebaseManager()
            let authViewModel = AuthViewModel(authenticator: FirebaseAuthenticator(), firebaseManager: firebaseManager)
            _authVM = StateObject(wrappedValue: authViewModel)

            // Initialize FavoritesViewModel with the FirebaseManager and AuthViewModel
            let favoritesVM = FavoritesViewModel<Restaurant>(firebaseManager: firebaseManager, authViewModel: authViewModel)
            _favoritesViewModel = StateObject(wrappedValue: favoritesVM)
        }

    var body: some Scene {
        WindowGroup {
            if authVM.userSession != nil {
                TabViewUI() // your main app view
                    .environmentObject(authVM)
                    .environmentObject(favoritesViewModel) // Supplying the ViewModel here
                    .onAppear {
                        authVM.listenToAuthChanges()
                        favoritesViewModel.initializeFavorites()
                    }
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
                    .environmentObject(networkStatusViewModel)
            } else {
                AuthView() // your authentication view
                    .environmentObject(authVM)
                    .onAppear {
                        authVM.listenToAuthChanges()
                    }
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
                    .environmentObject(networkStatusViewModel)
            }
        }
    }
}
