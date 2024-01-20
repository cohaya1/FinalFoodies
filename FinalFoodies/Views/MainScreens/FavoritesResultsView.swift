//
//  FavoritesResultsView.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 2/22/22.
//

import SwiftUI

struct FavoritesResultsView: View {
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel<Restaurant>
    @EnvironmentObject var networkStatusViewModel: NetworkStatusViewModel

    @State var rowspacing: CGFloat = 50
    @State private var selectedRestaurant: Restaurant? // Keep track of the selected restaurant
    @State private var showingDetail = false // Whether to show the detail view
    @State var restaurant: Restaurant?

  
    
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
    

    struct ResultsSearchItemView: View {
        var restaurant : Restaurant
        
        var restaurantImage: some View {
           Group {
              if let imageURL = restaurant.restaurantimage?.url, let url = URL(string: imageURL) {
                  CacheAsyncImage(url: url) { phase in
                      switch phase {
                      case .empty:
                          ProgressView()
                      case .success(let image):
                          image
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                              .clipShape(Circle()) // Clip the image to a circle shape
                      case .failure(_):
                          Image(systemName: "photo") // Placeholder image
                      @unknown default:
                          fatalError()
                      }
                  }
              } else {
                  Image(systemName: "photo") // Default placeholder image if the URL isn't available
                      .clipShape(Circle())
              }
          }
      }
        var dinnerplate: some View {
            ZStack {
                backgroundCircles
                restaurantImage
            }
            .compositingGroup()
            .frame(width: 281.21, height: 251.21)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 4, x: 0, y: 4)
        }
        
        var body: some View {
            ZStack {
                dinnerplate
                VStack(spacing: 15){
                    Text(restaurant.restaurantname ?? " ")
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
    
   
    var resultsSearchLabel: some View {
        //Found 6 results
        Text("Favorites").font(.system(size: 28, weight: .bold, design: .rounded)).multilineTextAlignment(.center)
            .foregroundColor(.red)
    }
}

private var backgroundCircles: some View {
    ZStack {
        Circle()
            .fill(Color.white.opacity(0.89))
        
        Circle()
            .strokeBorder(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 0.25)), lineWidth: 1)
    }
}
  



//struct FavoritesResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoritesResultsView()
//            .environmentObject(FavoritesViewModel<Restaurant>()) // Supplying the ViewModel here
//    }
//}
