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
    @State private var mapCoordinate =
    MKCoordinateRegion()
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))
            .frame(width: 464, height: 956)
            HStack(spacing: 260){
                backarrowicon
                hearticon
            }.padding(.bottom,700)
            VStack{
                dinnerplate
            }.padding(.bottom,400)
            VStack(spacing: 20) {
                restaurantname
                restaurantaddress
            }
            VStack(spacing: 200){
                restaurantdescription
               GoTolocationbutton
                    .padding(.leading,30)
                    .padding(.bottom,-200)
            }.padding(.top,400)
            VStack(alignment: .center) {
                Text("Deliver to Me").font(.system(size: 17, weight: .semibold, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0.98, green: 0.29, blue: 0.05, alpha: 1))).multilineTextAlignment(.center)
                    .padding(.leading,25)
            }.padding(.top,600)
        }
    }
    var backarrowicon: some View {
            Image("backarrowicon")
                .resizable()
                .frame(width: 15, height: 24)
                .scaledToFit()
        }
    var hearticon: some View {
        Image("hearticon")
            .resizable()
            .frame(width: 29, height: 25)
            .scaledToFit()
    }
    var dinnerplate: some View {
        ZStack {
            Circle()
                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                .opacity(0.89)
            

            Circle()
                .strokeBorder(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 0.25)), lineWidth: 1)
                
        }
        .compositingGroup()
        .frame(width: 281.21, height: 251.21)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0,alpha:1)), radius:4, x:0, y:4)
    }
    var restaurantname: some View {
        //Veggie tomato mix
        Text("Veggie tomato mix").font(.system(size: 28, weight: .semibold, design: .rounded)).multilineTextAlignment(.center)
    }
    var restaurantaddress: some View {
        //N1,900
        Text("N1,900").font(.system(size: 22, weight: .bold, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0.98, green: 0.29, blue: 0.05, alpha: 1))).multilineTextAlignment(.center)
    }
    var restaurantdescription: some View {
        VStack(spacing:10){
        //Delivery info
        Text("Story:").font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .padding(.trailing,220)
        //Delivered between monday a...
        Text("This is a discription for the restaurant\nPlease be adviced").font(.system(size: 15, weight: .regular)).tracking(0.3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
        }
    }
    var GoTolocationbutton: some View {
        //Rectangle 2
        ZStack {
        RoundedRectangle(cornerRadius: 30)
            .fill(Color(#colorLiteral(red: 0.9803921580314636, green: 0.29019609093666077, blue: 0.0470588244497776, alpha: 1)))
        .frame(width: 314, height: 70)
            //Add to cart
            Text("Go To Location ").font(.system(size: 17, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)))
        }
    }
}


struct DetailsPage_Previews: PreviewProvider {
    static var previews: some View {
        DetailsPage()
    }
}
