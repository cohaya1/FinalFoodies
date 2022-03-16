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
    var body: some View {
        tabviewselection
    }
    var tabviewselection: some View {
        
        TabView(selection: $tabSelection){
           HomePage()
        .tabItem{ Image("homeicon")
                   .renderingMode(.original)
                   .resizable(resizingMode: .stretch)
                   .aspectRatio(contentMode: .fill)
                   .foregroundColor(Color.red)
                  
                   .frame(width:144.565,height: 90)
        }.tag(1)
         
            // second tab
            FavoritesResultsView().tabItem { Image("heart") }.tag(2)
    
            SettingsView().tabItem { Image("user") }.tag(3)
        }
    }
}
    


struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewUI()
//            .padding(.all,-30)
//            .allowsTightening(true)
            
    }
}
