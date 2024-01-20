//
//  NearbySearchView.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 12/20/23.
//

import MapKit
import SwiftUI

struct NearbySearchView: View {
    @ObservedObject var viewModel: RestaurantFetcher

    var body: some View {
        List(viewModel.searchResults, id: \.id) { restaurant in  // Assuming each Restaurant has a unique 'id'
            VStack(alignment: .leading) {
                Text(restaurant.restaurantname ?? " ")
                Text(restaurant.restaurantlocation ?? "Online Only")
            }
        }
        .onAppear {
            Task {
                await viewModel.searchNearby(category: "Restaurants")
            }
        }
    }
}


//#Preview {
//    NearbySearchView()
//}
