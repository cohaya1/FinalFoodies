//
//  FavoritesResultsView.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 2/22/22.
//

import SwiftUI

struct FavoritesResultsView: View {
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel<Restaurant>

    @State var rowspacing: CGFloat = 50
    @State private var selectedRestaurant: Restaurant? // Keep track of the selected restaurant
    @State private var showingDetail = false // Whether to show the detail view
    
  
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(#colorLiteral(red: 0.9607843160629272, green: 0.9607843160629272, blue: 0.9725490212440491, alpha: 1)))
                .frame(width: 454, height: 985)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    resultsSearchLabel.padding(.top,90)
                    
                    let twocolumns = [GridItem(.fixed(-30),spacing: 188.90), GridItem(.fixed(20),spacing: 95)]
                    
                    ScrollView {
                        LazyVGrid(columns:twocolumns, spacing: rowspacing) {
                            ForEach(favoritesViewModel.favorites, id: \.id) { restaurant in
                                // Add a button to handle the tap
                                Button(action: {
                                    self.selectedRestaurant = restaurant
                                }) {
                                    ResultsSearchItemView(restaurant: restaurant)
                                }
                            }
                            .padding(.bottom,-270)
                        }
                    }
                }
            }
            .fullScreenCover(item: $selectedRestaurant) { selectedRestaurant in
                DetailsPage(restaurant: selectedRestaurant)
            }
        }
    }
    var resultsSearchLabel: some View {
        //Found 6 results
        Text("Favorites").font(.system(size: 28, weight: .bold, design: .rounded)).multilineTextAlignment(.center)
            .foregroundColor(.red)
    }
}


struct ResultsSearchItemView: View {
    var restaurant: Restaurant
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .frame(width: 145, height: 220)
            .shadow(color: Color(#colorLiteral(red: 0.22499999403953552, green: 0.22499999403953552, blue: 0.22499999403953552, alpha:  0.10000000149011612)), radius:60, x:0, y:30)
           
            ZStack {
                Circle()
                .fill(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))

                Circle()
                .strokeBorder(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)), lineWidth: 1)
            }
            .compositingGroup()
            .frame(width: 114.2, height: 164.2)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 4)), radius:4, x:0, y:4)
            .padding(.bottom,200)
            VStack(spacing: 15){
                              Text(restaurant.restaurantname)
                                  .font(.system(size: 22, weight: .semibold, design: .rounded))
                                  .multilineTextAlignment(.center)
//                              Text("N \(restaurant.restaurantrating)")
//                                  .font(.system(size: 17, weight: .bold, design: .rounded))
//                                  .foregroundColor(Color(#colorLiteral(red: 0.98, green: 0.29, blue: 0.05, alpha: 1)))
//                                  .multilineTextAlignment(.center)
                          }.padding(.top,80)
        }
    }
}

struct FavoritesResultsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesResultsView()
            .environmentObject(FavoritesViewModel<Restaurant>()) // Supplying the ViewModel here
    }
}
