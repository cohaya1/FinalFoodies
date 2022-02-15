//
//  NointernetView.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 2/12/22.
//

import SwiftUI

struct NointernetView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))
            .frame(width: 464, height: 956)
            VStack{
                nointernetimage
            }.padding(.bottom,250)
            VStack(spacing:15) {
                nointernetlabel
                nointernetdescription
                }
            VStack {
                tryagainbutton
            }.padding(.top,260)
        }
    }
    var nointernetimage: some View {
        Button(action: {}, label: {

        Image("nointernet")
            .resizable()
            .frame(width: 160, height: 160, alignment: .center)
        })
               }
    

    var nointernetlabel: some View {
        //No internet Connection
        Text("No internet Connection").font(.system(size: 28, weight: .semibold)).multilineTextAlignment(.center)
            .foregroundColor( Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
    }
    var nointernetdescription: some View {
        //Your internet connection i...
        Text("Your internet connection is currently\nnot available please check or try again.").font(.system(size: 17, weight: .regular)).multilineTextAlignment(.center)
            .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
    }
    var tryagainbutton : some View {
        //Rectangle 2
        ZStack {
        RoundedRectangle(cornerRadius: 30)
            .fill(Color(#colorLiteral(red: 0.9803921580314636, green: 0.29019609093666077, blue: 0.0470588244497776, alpha: 1)))
        .frame(width: 314, height: 70)
            //Try again
            Text("Try again").font(.system(size: 17, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.96, green: 0.96, blue: 0.98, alpha: 1))).multilineTextAlignment(.center)
        }
    }
}

struct NointernetView_Previews: PreviewProvider {
    static var previews: some View {
        NointernetView()
    }
}
