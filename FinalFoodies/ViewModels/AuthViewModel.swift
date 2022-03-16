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


 class AuthViewModel: ObservableObject {
   
    init() {
        userSession = Auth.auth().currentUser
    }
    

    @Published var userSession: Firebase.User?
    @Published var hasError: Bool = false
    static let shared = AuthViewModel()
    
    func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if let err = err {
                print(err.localizedDescription)
                    
                return
            }
            
            guard let user = result?.user else { return }
            
            self.userSession = user
            
        }
    }
    func logout() {
        self.userSession = nil
        try? Auth.auth().signOut()
        
    }
    
    
    func register(withEmail email: String, password: String, username: String, name: String?) {
        Auth.auth().createUser(withEmail: email, password: password ) {
            (result,err) in
            if let err = err{
                print(err.localizedDescription)
                return
            }
            guard let user = result?.user else {return}
            let data = ["email": email,"username": username,"name":name,"uid":user.uid]
            Firestore.firestore().collection("users").document(user.uid).setData(data as [String : Any]) {
                err in
                if let err = err {
                    print(err.localizedDescription)
                    
                    return
                }
                print("Debug ")
            }
        }
    }
}
