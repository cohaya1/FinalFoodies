//
//  AlertView.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 2/13/22.
//

import SwiftUI

struct AlertView: View, Error {
    @State  var Alertselected : SwitchAlertOption?
    var body: some View {
        ZStack {
            switch Alertselected{
            case .show404email: invalidEmail
            case .show404password: invalidPassword
            case .show500Serverdown: invalid500ErrorMessage
            default: invalidEmail
            }
            }    }
}
var invalidEmail: some View {
    //Rectangle 65
    ZStack{
        ZStack {                Color.black.opacity(0.4)                    .ignoresSafeArea();                      VStack(spacing: 20) {            Text("Error Message: 404 Unathorized")                       .bold()                        .frame(width: 350, height: 50 )            .background(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))
                .foregroundColor(Color.black);
            
            Text("Please type in the right email address and in the correct format")
                .font(.system(size: 15, weight: .bold)).tracking(0.3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                //Available in iOS 14 only
                .textCase(.uppercase)
                .foregroundColor(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))
                .padding(.top,60)
            Spacer();                HStack(spacing:25) {
                    Button(action: {}){
                        //Rectangle 66
                        //Cancel
                        Text("Cancel").font(.custom("Poppins SemiBold", size: 17))
                           .foregroundColor(.gray)
                    }
                    Button(action: {}){
                        ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(#colorLiteral(red: 0.9803921580314636, green: 0.29019609093666077, blue: 0.0470588244497776, alpha: 1)))
                        .frame(width: 159, height: 60)
                            //Proceed
                            Text("Try again").font(.custom("Poppins SemiBold", size: 17)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        }
                    }
                }.padding()                                                                     }.frame(width: 315, height: 322)                .background(Color.white)                .cornerRadius(20).shadow(radius: 20)
            
        }

    }
        }
        
        
var invalidPassword: some View {
    //Rectangle 65
    ZStack{
        ZStack {                Color.black.opacity(0.4)                    .ignoresSafeArea();                      VStack(spacing: 20) {            Text("Error Message: 404 Unathorized")                       .bold()                        .frame(width: 350, height: 50 )            .background(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))
                .foregroundColor(Color.black);
            
            Text("Please type in the right email address and in the correct format")
                .font(.system(size: 15, weight: .bold)).tracking(0.3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                //Available in iOS 14 only
                .textCase(.uppercase)
                .foregroundColor(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))
                .padding(.top,60)
            Spacer();                HStack(spacing:25) {
                    Button(action: {}){
                        //Rectangle 66
                        //Cancel
                        Text("Cancel").font(.custom("Poppins SemiBold", size: 17))
                           .foregroundColor(.gray)
                    }
                    Button(action: {}){
                        ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(#colorLiteral(red: 0.9803921580314636, green: 0.29019609093666077, blue: 0.0470588244497776, alpha: 1)))
                        .frame(width: 159, height: 60)
                            //Proceed
                            Text("Try again").font(.custom("Poppins SemiBold", size: 17)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        }
                    }
                }.padding()                                                                     }.frame(width: 315, height: 322)                .background(Color.white)                .cornerRadius(20).shadow(radius: 20)
            
        }

    }
        }
var invalid500ErrorMessage: some View {
    //Rectangle 65
    ZStack{
        ZStack {                Color.black.opacity(0.4)                    .ignoresSafeArea();                      VStack(spacing: 20) {            Text("Error Message: 404 Unathorized")                       .bold()                        .frame(width: 350, height: 50 )            .background(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))
                .foregroundColor(Color.black);
            
            Text("Please type in the right email address and in the correct format")
                .font(.system(size: 15, weight: .bold)).tracking(0.3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                //Available in iOS 14 only
                .textCase(.uppercase)
                .foregroundColor(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))
                .padding(.top,60)
            Spacer();                HStack(spacing:25) {
                    Button(action: {}){
                        //Rectangle 66
                        //Cancel
                        Text("Cancel").font(.custom("Poppins SemiBold", size: 17))
                           .foregroundColor(.gray)
                    }
                    Button(action: {}){
                        ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(#colorLiteral(red: 0.9803921580314636, green: 0.29019609093666077, blue: 0.0470588244497776, alpha: 1)))
                        .frame(width: 159, height: 60)
                            //Proceed
                            Text("Try again").font(.custom("Poppins SemiBold", size: 17)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        }
                    }
                }.padding()                                                                     }.frame(width: 315, height: 322)                .background(Color.white)                .cornerRadius(20).shadow(radius: 20)
            
        }

    }
}
enum SwitchAlertOption { // create enum to switch between login and register
    case show404email
    case show404password
    case show500Serverdown
  
}
struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView()
    }
}

