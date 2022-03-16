//
//  SettingsView.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 2/13/22.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack{
            //iPhone 11 Pro Max - 10
            //iPhone 11 Pro Max - 13
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(#colorLiteral(red: 0.9607843160629272, green: 0.9607843160629272, blue: 0.9725490212440491, alpha: 1)))
            .frame(width: 454, height: 985)
            VStack(spacing: 40){
               backarrow
                    .padding(.trailing,140)
               myprofilelabel
            }.padding(.trailing,200)
                .padding(.bottom,700)
            VStack {
                HStack(spacing:185){
                    personaldetailslabel
                    changepasswordbutton
                }
                
            }.padding(.bottom,500)
            VStack(spacing:25){
                profileholdview
                locationview
                donationsview
                requestrestaurantview
            
            }
            VStack{
                signoutbutton.padding(.top,650)
            }
        }
    }
    var backarrow: some View {
        
        Image("backarrowicon")
            .resizable()
            .frame(width: 6, height: 12)
    }
    var myprofilelabel: some View {
        //My profile
        Text("My profile").font(.system(size: 34, weight: .semibold))
            .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
    }
    var personaldetailslabel: some View {
        //Personal details
        Text("Personal details").font(.system(size: 18, weight: .semibold))
            .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
        
    }
    var changepasswordbutton: some View {
        //change
        Text("change").font(.system(size: 15, weight: .regular)).foregroundColor(Color(#colorLiteral(red: 0.98, green: 0.29, blue: 0.05, alpha: 1)))
    }
    
    var profileholdview: some View {
        ZStack{
            //Rectangle 10
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .frame(width: 315, height: 197)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.029999999329447746)), radius:40, x:0, y:10)
            HStack {
           profileimageview
                    .padding(.trailing,200)
                    .padding(.bottom,69.5)
            }
           
                VStack(spacing:5){
                    namelabel.padding(.trailing,25)
                
            emaillabel
                        .padding(.bottom,105)
                           
                }.padding(.leading,115)
            VStack{
                phonenumber
                    .foregroundColor(Color.gray)
            }.padding(.bottom)
                .padding(.leading,70)
            
            VStack(spacing: 28.5) {
                lineseparator
                
                lineseparator
            }.padding(.leading,115)
                .padding(.bottom)
                VStack {
                    
                    addresslabel.padding(.leading,200)
                        .padding(.top,80)
                    
                        
                }
            }
            }
        }
    
    


var profileimageview: some View {
    //Rectangle 6
    ZStack {
        RoundedRectangle(cornerRadius: 10)
        .fill(Color(#colorLiteral(red: 0.7686274647712708, green: 0.7686274647712708, blue: 0.7686274647712708, alpha: 1)))

        Image(" ")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 91, height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    .frame(width: 91, height: 100)
}
var namelabel: some View {
    //Marvis Ighedosa
    Text("Marvis Ighedosa").font(.system(size: 18, weight: .semibold))
}
var emaillabel: some View {
    
    Text("chika.ohaya@gmail.com").font(.system(size: 15, weight: .regular))
        .foregroundColor(/*@START_MENU_TOKEN@*/.gray/*@END_MENU_TOKEN@*/)
        .lineLimit(1)
        
        
}
var lineseparator: some View {
    Image("Line 1")
        .resizable()
        .frame(width: 165, height: 1, alignment: .center)
}
var phonenumber: some View {
    //+234 9011039271
    Text("+234 9011039271").font(.system(size: 15, weight: .regular))
}
var addresslabel: some View {
    //No 15 uti street off ovie ...
    Text("No 15 uti street off ovie palace road effurun delta state").font(.system(size: 15, weight: .regular))
        .multilineTextAlignment(.leading)
        .lineLimit(3)
        .allowsTightening(true)
        .foregroundColor(Color.gray)
        .padding(.trailing,70)
}
    var donationsview: some View {
        ZStack {
        //chevron-left
           
        //Rectangle 10
            RoundedRectangle(cornerRadius: 20)
            .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .frame(width: 325, height: 60)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.029999999329447746)), radius: 40, x: 0, y: 10)
            HStack(spacing:60) {
           
            
            
        //Orders
            Text("Donations").font(.system(size: 18, weight: .semibold))
                    .padding(.trailing,100)
            Image("Gotoarrow")
                    .resizable()
                    .frame(width: 24, height: 24, alignment: .leading)
            }
            
        }
    }
var locationview: some View {
    ZStack {
    //chevron-left
       
    //Rectangle 10
        RoundedRectangle(cornerRadius: 20)
        .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
        .frame(width: 325, height: 60)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.029999999329447746)), radius: 40, x: 0, y: 10)
        HStack(spacing:60) {
       
        
        
    //Orders
        Text("Change Location").font(.system(size: 18, weight: .semibold))
                .padding(.trailing,40)
        Image("Gotoarrow")
                .resizable()
                .frame(width: 24, height: 24, alignment: .leading)
        }
        
    }
}
var requestrestaurantview: some View {
    ZStack {
    //chevron-left
       
    //Rectangle 10
        RoundedRectangle(cornerRadius: 20)
        .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
        .frame(width: 325, height: 60)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.029999999329447746)), radius: 40, x: 0, y: 10)
        HStack(spacing:60) {
       
        
        
    //Orders
        Text("Request a Restaurant").font(.system(size: 18, weight: .semibold))
                .padding(.trailing,1)
        Image("Gotoarrow")
                .resizable()
                .frame(width: 24, height: 24, alignment: .leading)
                .padding(.leading,2)
        }
        
    }
}
    var signoutbutton: some View {
        Button(action: {}){
            ZStack {
            //Update
                RoundedRectangle(cornerRadius: 30)
                .fill(Color(#colorLiteral(red: 0.9803921580314636, green: 0.29019609093666077, blue: 0.0470588244497776, alpha: 1)))
                .frame(width: 314, height: 70)
                Text("SignOut").font(.system(size: 17, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.96, green: 0.96, blue: 0.98, alpha: 1))).multilineTextAlignment(.center)

            //Rectangle 2
            
            }
        }
    }

//Vector

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
