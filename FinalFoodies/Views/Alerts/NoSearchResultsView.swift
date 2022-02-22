//
//  NoSearchResultsView.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 2/22/22.
//

import SwiftUI

struct NoSearchResultsView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))
            .frame(width: 464, height: 956)
            VStack(spacing: 18) {
            searchiconimage
            itemnotfoundlabel
            itemnotfounddesc
            }.padding(.bottom,60)
        }
    }
    var searchiconimage: some View {
        Image("Searchbutton")
            .resizable()
            .frame(width: 131.5, height: 131.5, alignment: .center)
    }
    var itemnotfoundlabel: some View {
        //Item not found
        Text("Item not found").font(.system(size: 28, weight: .semibold)).multilineTextAlignment(.center)
    }
    var itemnotfounddesc: some View {
        //Try searching the item wit...
        Text("Try searching the item with\na different keyword.").font(.system(size: 17, weight: .regular)).multilineTextAlignment(.center)
            .foregroundColor(.gray)
    }
}

struct NoSearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NoSearchResultsView()
    }
}
