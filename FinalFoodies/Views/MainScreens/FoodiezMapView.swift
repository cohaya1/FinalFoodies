//
//  FoodiezMapView.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 12/20/23.
//

import SwiftUI
import MapKit

struct FoodiezMapView: View {
    @ObservedObject private var viewModel = RestaurantFetcher()
        @State private var localRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33.7490, longitude: -84.3880), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        @State private var userTrackingMode: MapUserTrackingMode = .follow
        @State private var selectedRestaurant: Restaurant?
        @State private var showDirectionsPanel = false
        @State private var showNearbySearchPanel = false

        var body: some View {
            ZStack {
                Map(coordinateRegion: $localRegion,
                    interactionModes: .all,
                    showsUserLocation: true,
                    userTrackingMode: $userTrackingMode,
                    annotationItems: viewModel.restaurants) { restaurant in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: restaurant.restaurantlatitude ?? 0, longitude: restaurant.restaurantlongitude ?? 0)) {
                        Button(action: {
                            selectedRestaurant = restaurant
                            showDirectionsPanel = true
                            // Manually update the local region if necessary
                            localRegion.center = CLLocationCoordinate2D(latitude: restaurant.restaurantlatitude ?? 0, longitude: restaurant.restaurantlongitude ?? 0)
                        }) {
                            Label(restaurant.restaurantname ?? " ", systemImage: "fork.knife")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .mapStyle(.hybrid(elevation: .realistic))
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    viewModel.requestLocationPermission()
                }
        }
        //
        //            // Overlay Panel for Directions
        //            if showDirectionsPanel, let restaurant = selectedRestaurant {
        //                DirectionsView(viewModel: DirectionsViewModel(), restaurant: restaurant)
        //                    .transition(.move(edge: .bottom))
        //                    .zIndex(1)
        //            }
        //
        //            // Overlay Panel for Nearby Search
        //            if showNearbySearchPanel {
        //                NearbySearchView(viewModel: viewModel)
        //                    .transition(.move(edge: .bottom))
        //                    .zIndex(1)
        //            }
        
        // Buttons to toggle panels
    }
    }

    // ... TogglePanelButton, RestaurantAnnotationView, and PrimaryButtonStyle ...


   
        // Toggle Panel Button View
        private func TogglePanelButton(title: String, isActive: Binding<Bool>) -> some View {
            Button(title) {
                isActive.wrappedValue.toggle()
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding()
        }



    
    struct RestaurantAnnotationView: View {
        var restaurant: Restaurant
        
        var body: some View {
            VStack {
                Image(systemName: "fork.knife")
                    .foregroundColor(.blue)
                Text(restaurant.restaurantname ?? " ")
                    .font(.caption)
            }
        }
    }


struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.blue.cornerRadius(8))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    
        FoodiezMapView()
   
}
