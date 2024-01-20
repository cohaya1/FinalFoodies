//
//  HomePage.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 2/12/22.
//

import SwiftUI

struct HomePage: View {
    @State private var showingDetail = false
    @State private var searchText = ""
    @StateObject var viewModel : RestaurantFetcher
    @State private var selectedRestaurant: Restaurant?
    @ObservedObject var activityVM = ActivityIndicatorViewModel()
    @EnvironmentObject var networkStatusViewModel: NetworkStatusViewModel

    var refreshButton: some View {
        Button(action: {
            Task {
                await activityVM.performAsyncTask()
                await viewModel.refresh()
            }
        }) {
            Image(systemName: "arrow.clockwise")
                .resizable()
                .frame(width: 24, height: 24)
        }
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        HStack {
                            Spacer()
                            settingsicon
                        }.padding(.top, 30)
                        Spacer()

                        VStack {
                            delicioustext
                            SearchTextField
                        }
                        Spacer()

                        HStack {
                            Spacer()
                            Button(action: {}, label: {
                                Text("see more").font(.system(size: 15, weight: .regular, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0.98, green: 0.29, blue: 0.05, alpha: 1)))
                            })
                            Spacer()
                            refreshButton
                        }
                        Spacer()

                        if activityVM.isLoading {
                            CustomProgressView()
                        } else {
                            ScrollView(Axis.Set.horizontal, showsIndicators: false) {
                                HStack(spacing: 45) {
                                    let restaurants = searchText.isEmpty ? viewModel.restaurants : viewModel.searchResults
                                    if restaurants.isEmpty {
                                        Text("No results found")
                                            .font(.title)
                                            .foregroundColor(.gray)
                                            .padding()
                                    } else {
                                        ForEach(restaurants, id: \.self) { restaurant in
                                            Button(action: {
                                                self.selectedRestaurant = restaurant
                                            }) {
                                                RestaurantTableItem(restaurant: restaurant)
                                            }
                                            if !networkStatusViewModel.isNetworkAvailable {
                                                NoInternetPopup()
                                                    .transition(.opacity) // Transition effect for the popup
                                            }
                                        }
                                    }
                                }
                            }
                        

                            .frame(height: 300)
                            .padding()
                            
                            .onAppear {
                                    Task {
                                        
                                        await viewModel.getAllRestaurants()
                                    }
                                }                            .onChange(of: searchText) 
                            { newValue in
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    viewModel.search(newValue)
                                }
                                
                            }
                            .scaleEffect(searchText.isEmpty ? 1.0 : 1.2)
                            .animation(.easeInOut(duration: 0.2), value: searchText)
                            .navigationBarHidden(true)
                            .fullScreenCover(item: $selectedRestaurant) { selectedRestaurant in
                                DetailsPage(restaurant: selectedRestaurant)
                                
                                // No Internet Connection Popup
                                                   
                            }
                        }
                    }
                }
            }
        }
    }


    // Your other variables


      

    // Components
    var settingsicon: some View {
        Image("settingsicon")
            .resizable()
            .frame(width: 22, height: 14.67)
            .scaledToFit()
    }
    var delicioustext: some View {
        //Delicious food for you
        Text("Delicious \nfood for you").font(.system(size: 34, weight: .bold, design: .rounded))
    }
    var SearchTextField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search", text: $searchText)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
        }
        .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(#colorLiteral(red: 0.9375, green: 0.93359375, blue: 0.93359375, alpha: 1)))
                .frame(height: 60)
        )
        .padding(.horizontal)
    }


   

var restauranttable: some View {
    
   // let restaurant : Restaurant
    
    
    ZStack {
       
        //Ellipse 2
       
        //Rectangle 9
        
        
        
        RoundedRectangle(cornerRadius: 30)
            .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
        .frame(width: 220, height: 270)
        .shadow(color: Color(#colorLiteral(red: 0.22499999403953552, green: 0.22499999403953552, blue: 0.22499999403953552, alpha: 0.10000000149011612)), radius:60, x:0, y:30)
       
            
        //Ellipse 2
        // Composition groups need to live inside some a stack. (VStack, ZStack, or HStack)

        ZStack {
            Circle()
            .fill(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))

            Circle()
            .strokeBorder(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)), lineWidth: 1)
        }
        .compositingGroup()
        .frame(width: 164.2, height: 174.2)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 4)), radius:4, x:0, y:4)
        .padding(.bottom,200)
        VStack(spacing: 25){
            Text("viewModel.resta").font(.system(size: 22, weight: .semibold, design: .rounded)).multilineTextAlignment(.center)
        Text("N1,900").font(.system(size: 17, weight: .bold, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0.98, green: 0.29, blue: 0.05, alpha: 1))).multilineTextAlignment(.center)
       
        }.padding(.top,100)
    }

}
}


//struct HomePage_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePage()
//    }
//}
