//
//  DetailsPage.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 2/12/22.
//

import CoreLocation
import CoreLocationUI
import MapKit
import SwiftUI

struct DetailsPage: View {
    let restaurant: Restaurant
    @StateObject var viewModel = DetailsPageViewModel()
    @State private var isShareSheetShowing = false
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel<Restaurant>
    @Environment(\.dismiss) var dismiss // <--- add this line
    
    @State private var mapCoordinate =
    MKCoordinateRegion()
    var body: some View {
        ZStack { // <-- Change NavigationView to ZStack
            GeometryReader { geometry in
                ScrollView {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.9)
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack {
                            HStack {
                                backarrowicon
                                Spacer()
                                hearticon
                            }.padding(.top, 30)
                            Spacer()
                            
                            dinnerplate
                            Spacer()
                            
                            VStack(spacing: 20) {
                                restaurantname
                                restaurantaddress
                                sharebutton
                            }
                            Spacer()
                            
                            VStack {
                                restaurantdescription
                                GoTolocationbutton
                            }
                            Spacer()
                            
                            Text("Deliver to Me").font(.system(size: 17, weight: .semibold, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0.98, green: 0.29, blue: 0.05, alpha: 1))).multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    var backarrowicon: some View {
        Button(action: { // <-- Replace NavigationLink with Button
            dismiss() // <-- This is the dismiss action
        }) {
            Image("backarrowicon")
                .resizable()
                .frame(width: 15, height: 24)
                .scaledToFit()
        }
    }
    var hearticon: some View {
        Button(action: {
            if favoritesViewModel.favorites.contains(where: { $0.id == restaurant.id }) {
                favoritesViewModel.removeFromFavorites(restaurant)
            } else {
                favoritesViewModel.addToFavorites(restaurant)
            }
        }) {
            Image(
                favoritesViewModel.favorites.contains(where: { $0.id == restaurant.id })
                ? "hearticon_filled"
                : "hearticon"
            )
            .resizable()
            .frame(width: 29, height: 25)
            .scaledToFit()
        }
    }

    var dinnerplate: some View {
        ZStack {
            
            Circle()
                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                .opacity(0.89)
            
            
            Circle()
                .strokeBorder(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 0.25)), lineWidth: 1)
            if restaurant.restaurantimage?.url != nil {
                AsyncImage(url: URL(string: restaurant.restaurantimage!.url))
            }
        }
        .compositingGroup()
        .frame(width: 281.21, height: 251.21)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0,alpha:1)), radius:4, x:0, y:4)
    }
    var restaurantname: some View {
        //Veggie tomato mix
        Text(restaurant.restaurantname).font(.system(size: 28, weight: .semibold, design: .rounded)).multilineTextAlignment(.center)
    }
    var restaurantaddress: some View {
        //N1,900
        Text(restaurant.restaurantlocation).font(.system(size: 22, weight: .bold, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0.98, green: 0.29, blue: 0.05, alpha: 1))).multilineTextAlignment(.center)
    }
    var restaurantdescription: some View {
        VStack(spacing:10){
            //Delivery info
            Text("Story:").font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .padding(.trailing,220)
            //Delivered between monday a...
            Text(restaurant.restaurantdescription).font(.system(size: 15, weight: .regular)).tracking(0.3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
        }
    }
    var sharebutton: some View {
        VStack {
                  // Your other view components here
                  Button(action: {
                      self.isShareSheetShowing = true
                  }) {
                      Text("Share")
                  }
                  .sheet(isPresented: $isShareSheetShowing) {
                      ActivityViewController(activityItems: [restaurant.restaurantname, restaurant.restaurantlocation])
                  }
              }
          }
    

    var GoTolocationbutton: some View {
        Button(action: {
            viewModel.goToLocation(restaurant.restaurantlocation)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(#colorLiteral(red: 0.9803921580314636, green: 0.29019609093666077, blue: 0.0470588244497776, alpha: 1)))
                    .frame(width: 314, height: 70)
                //Add to cart
                Text("Go To Location ").font(.system(size: 17, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)))
            }
        }
    }
}

//struct DetailsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailsPage(restaurant: Restaurant(0, 0, "", "", 0.0, "", 0,Double(0.0),Double(0.0), nil, Restaurantimage(path: "", name:"",type: .image, size: 0, mime: "", meta: Meta(width: 10, height: 10), url: "")))
//    }
//}
