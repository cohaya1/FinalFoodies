//
//  AuthViewModel.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 3/3/22.
//

import Combine
import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

protocol Authenticator {
    func login(withEmail: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func logout() throws
    func register(withEmail: String, password: String, name: String, completion: @escaping (Result<User, Error>) -> Void)
    var currentUser: User? { get }
}

class FirebaseAuthenticator: Authenticator {
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    func login(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    func register(withEmail email: String, password: String, name: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                let data = ["email": email, "name": name, "uid": user.uid]
                Firestore.firestore().collection("users").document(user.uid).setData(data as [String : Any]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(user))
                    }
                }
            }
        }
    }
}

class AuthViewModel: ObservableObject {
    @Published var userSession: User?
    @Published var hasError: Bool = false
    @Published var errorString = ""

    private var handle: AuthStateDidChangeListenerHandle?

   // private var cancellables = Set<AnyCancellable>()
    private var authenticator: Authenticator
    
    init(authenticator: Authenticator) {
        self.authenticator = authenticator
        userSession = authenticator.currentUser
    }
    
    func login(withEmail email: String, password: String) {
        authenticator.login(withEmail: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                self?.userSession = user
            case .failure(let error):
                self?.hasError = true
                self?.errorString = error.localizedDescription
                print(error.localizedDescription)
            }
        }
    }

    
    func logout() {
        do {
            try authenticator.logout()
            userSession = nil
        } catch {
            print(error.localizedDescription)
            hasError = true
        }
    }
    
    func register(withEmail email: String, password: String, name: String) {
        authenticator.register(withEmail: email, password: password, name: name) { [weak self] result in
            switch result {
            case .success(let user):
                self?.userSession = user
            case .failure(let error):
                self?.hasError = true
                self?.errorString = error.localizedDescription
                print(error.localizedDescription)            }
        }
    }
    func listenToAuthChanges() {
            handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                self.userSession = user
            }
        }
        
        deinit {
            if let handle = handle {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
    }
    

