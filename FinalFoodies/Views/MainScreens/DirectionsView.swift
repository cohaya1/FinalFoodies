//
//  DirectionsView.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 12/20/23.
//

import SwiftUI

struct DirectionsView: View {
    @StateObject var viewModel: DirectionsViewModel
    var restaurant: Restaurant
    @State private var isLoading = true

    var body: some View {
        List {
            if isLoading {
                Text("Loading directions...")
            } else if viewModel.directions.isEmpty {
                Text("No directions available.")
            } else {
                ForEach(viewModel.directions, id: \.self) { direction in
                    Text(direction)
                }
            }
        }
        .onAppear {
            viewModel.calculateDirections(to: restaurant) {
                isLoading = false
            }
        }
        .navigationTitle("Directions")
    }
}


//#Preview {
//    DirectionsView()
//}
