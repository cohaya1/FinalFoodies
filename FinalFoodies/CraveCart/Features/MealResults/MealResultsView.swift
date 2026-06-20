//
//  MealResultsView.swift
//  FinalFoodies / CraveCart
//
//  Screen 2 of the MVP: the three meal paths for a craving. Currently
//  embedded in CravingHomeView; can become a standalone pushed screen later.
//

import SwiftUI

struct MealResultsView: View {
    let options: [MealOption]
    var onSave: ((MealOption) -> Void)? = nil

    var body: some View {
        ForEach(options) { option in
            MealCardView(option: option, onSave: onSave.map { cb in { cb(option) } })
        }
    }
}
