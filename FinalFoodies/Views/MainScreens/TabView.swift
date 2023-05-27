//
//  TabView.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 2/22/22.
//

import SwiftUI

struct TabViewUI: View {
    @State var isPresenting = false
    @State var tabSelection = 1
    @MainActor let viewModel = RestaurantFetcher( using: NetworkManager())

    var body: some View {
        TabView(selection: $tabSelection){
            HomePage(viewModel: viewModel)
                .tabItem {
                    VStack {
                        Image("homeicon")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                        Text("Home")
                    }
                }.tag(1)
         
            // second tab
            FavoritesResultsView()
                .tabItem {
                    VStack {
                        Image("heart")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                        Text("Favorites")
                    }
                }.tag(2)
    
            SettingsView()
                .tabItem {
                    VStack {
                        Image("user")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                        Text("Settings")
                    }
                }.tag(3)
        }
        .accentColor(.red)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewUI()
    }
}
