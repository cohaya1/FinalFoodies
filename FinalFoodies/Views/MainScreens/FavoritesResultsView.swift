//
//  FavoritesResultsView.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 2/22/22.
//

import SwiftUI

struct FavoritesResultsView: View {
    @State var rowspacing: CGFloat = 50
    var body: some View {
        
        ZStack{
            //iPhone 11 Pro Max - 10
            //iPhone 11 Pro Max - 13
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(#colorLiteral(red: 0.9607843160629272, green: 0.9607843160629272, blue: 0.9725490212440491, alpha: 1)))
            .frame(width: 454, height: 985)
            VStack {
                resultsSearchLabel.padding(.top,100)
                
                let twocolumns = [GridItem(.fixed(-30),spacing: 188.90),GridItem(.fixed(20),spacing: 95)]
                
                ScrollView {
                   
                LazyVGrid(columns:twocolumns, spacing: rowspacing) {
                    
                    ForEach(1..<10) {
                        item in
                resultsSeachItem
                    }.padding(.bottom,-270)
                }
                    
                }
            }

        }
    }
    var resultsSearchLabel: some View {
        //Found 6 results
        Text("Favorites").font(.system(size: 28, weight: .bold, design: .rounded)).multilineTextAlignment(.center)
            .foregroundColor(.red)
    }
    var resultsSeachItem: some View {
        ZStack {
           
            //Ellipse 2
           
            //Rectangle 9
            
            
            
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .frame(width: 145, height: 220)
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
            .frame(width: 114.2, height: 164.2)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 4)), radius:4, x:0, y:4)
            .padding(.bottom,200)
            VStack(spacing: 15){
                Text("Veggie \ntomato mix").font(.system(size: 22, weight: .semibold, design: .rounded)).multilineTextAlignment(.center)
            Text("N1,900").font(.system(size: 17, weight: .bold, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0.98, green: 0.29, blue: 0.05, alpha: 1))).multilineTextAlignment(.center)
           
            }.padding(.top,80)
        }
    }
}
struct FavoritesResultsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesResultsView()
    }
}
