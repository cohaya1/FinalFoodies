//
//  FinalFoodiesApp.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 2/12/22.
//
import Firebase
import SwiftUI

@main
struct FinalFoodiesApp: App {
   
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
           TabViewUI()
        }
    }
}
