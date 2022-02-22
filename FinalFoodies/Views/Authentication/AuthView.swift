//
//  AuthView.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 2/12/22.
//

import SwiftUI

struct AuthView: View {
    @State  var subviewSelected : SwitchViewOption?
    @State private var isPressed = false
    @State private var isPressed2 = false
    @State private var showlogin = true
    @State private var showregister = false
    var body: some View {
        ZStack {
            switch subviewSelected{
            case .showlogin: LoginView()
            case .showregister: SignUpView()
            default: LoginView()
                
            }
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))
//            .frame(width: 464, height: 966)
           
                
            authselection
                .padding(.bottom,600)
            //Bella Olonje logo 111 1
            Image("chefhatbig")
                .resizable()
                .frame(width: 131.5, height: 162.4)
                .clipped()
                .scaledToFit()
                
            .padding(.bottom,565)
            HStack(spacing: 60){
                
            loginbutton
                    .buttonStyle(PlainButtonStyle())
                    .pressAction {
                        isPressed = true
                    } onRelease: {
                        isPressed = false
                    }
                SignUpbutton
                    .buttonStyle(PlainButtonStyle())
                    .pressAction {
                        isPressed2 = true
                    } onRelease: {
                        isPressed2 = false
                    }
                
            }.padding(.top,-153)
            
        }
        
    }
    
//    var subviews: some View {
//        ZStack {
//            //iPhone 11 Pro Max - 2
////            RoundedRectangle(cornerRadius: 20)
////                .fill(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))
////            .frame(width: 464, height: 966)
//            switch subviewSelected{
//            case .showlogin: (LoginView())
//            case .showregister:(SignUPView))
//           default:
//                LoginView()
//            }
//        }
//    }
    var loginbutton: some View {// login button
       
            
        Button(action: {
        
            subviewSelected = .showlogin
//                                        presentationMode.wrappedValue.dismiss()
        }, label: {
                //Rectangle 2
                VStack(spacing:20) {
                    Text("Login").font(.system(size: 18, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    //Rectangle 1
                    Image(!isPressed ? "":"redline")
                        .resizable()
                        .frame(width: 124, height: 10)
                       
                    
                }
                   })
                   }
    var SignUpbutton: some View {// signup button
       
            
        
            Button(action: {
            
                subviewSelected = .showregister
//                                        presentationMode.wrappedValue.dismiss()
            }, label: {
                //Rectangle 2
                VStack(spacing:20) {
                    Text("Sign-up").font(.system(size: 18, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    Image(!isPressed2 ? "":"redline")
                        .resizable()
                        .frame(width: 124, height: 10)
                    //Rectangle 1
//                    RoundedRectangle(cornerRadius: 40)
//                        .fill(Color(#colorLiteral(red: 0.9803921580314636, green: 0.29019609093666077, blue: 0.0470588244497776, alpha: 1)))
//                    .frame(width: 134, height: 3)
//                    .shadow(color: Color(#colorLiteral(red: 0.7666666507720947, green: 0.24712221324443817, blue: 0.08305555582046509, alpha: 0.10000000149011612)), radius:4, x:0, y:4)
                
                }
            
                   })
                   }
}
var authselection: some View{
    //Rectangle 3
    
    RoundedRectangle(cornerRadius: 30)
        .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
    .frame(width: 384, height: 382)
    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05999999865889549)), radius:30, x:0, y:4)
}
//var loginbuttonnored: some View {// login button
//
//
//        Button(action: {}, label: {
//            //Rectangle 2
//            VStack(spacing:20) {
//                Text("Login").font(.system(size: 18, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
//                         }
//               })
//               }
//var signupbuttonnored: some View {// login button
//
//
//        Button(action: {}, label: {
//            //Rectangle 2
//            VStack(spacing:20) {
//                Text("Login").font(.system(size: 18, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
//                         }
//               })
//               }


struct PressActions: ViewModifier {// cretead gesture view modifier
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}
 
enum SwitchViewOption { // create enum to switch between login and register
    case showlogin
    case showregister
  
}

extension View { // adding an extension to View with the modifier function  for pressing and releasing buttons
    func pressAction(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(PressActions(onPress: {
            onPress()
        }, onRelease: {
            onRelease()
        }))
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
