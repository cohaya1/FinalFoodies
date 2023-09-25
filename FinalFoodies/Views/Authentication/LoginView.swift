//
//  LoginView.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 2/12/22.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authvm: AuthViewModel
    @State private var navigateToHome = false
    @ObservedObject var activityVM = ActivityIndicatorViewModel()

    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))
            .frame(width: 464, height: 956)
           
            VStack(spacing:10) {
      
            Text("Email address").font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color .gray)
                .padding(.trailing,195.22)
              emailtextfield
                    .padding(.leading,90)
                
              Image("Line 1")
                    .resizable()
                    .frame(width: 294, height: 1 )
            }.padding(.bottom,100)
           
            VStack{
                Text("Password").font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color .gray)
                    .padding(.trailing,225.22)
                  passwordtextfield
                        .padding(.leading,90)
                    
                  Image("Line 1")
                        .resizable()
                        .frame(width: 294, height: 1 )
                
                
            }.padding(.top,150)
            
            VStack(spacing:140){
              forgetpasscodebutton
                    .padding(.trailing,150)
              
             loginbutton
                
            googleSignInButton
                
            }.padding(.top,530)
            
           
      
           
                
            
    }
    
   
    }
    var loginbutton: some View {
        Button(action: {
            // Start the async task when the button is clicked
            Task {
                await activityVM.performAsyncTask()
            }
            // Log in
            authvm.login(withEmail: email, password: password)
        }, label: {
            ZStack {
                // Show an activity indicator while the async task is in progress
                if activityVM.isLoading {
                    ProgressView()
                } else {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(#colorLiteral(red: 0.9803921580314636, green: 0.29019609093666077, blue: 0.0470588244497776, alpha: 1)))
                        .frame(width: 314, height: 70)
                    Text("Login")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(#colorLiteral(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)))
                }
            }
        })
        .alert(isPresented: $authvm.hasError) {
            Alert(title: Text("Login Error"), message: Text(authvm.errorString))
        }
    }

               
    var forgetpasscodebutton: some View {
        Button(action: {}, label: {
            //Rectangle 2
           
                //Forgot passcode?
                Text("Forgot passcode?").font(.system(size: 17, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.98, green: 0.29, blue: 0.05, alpha: 1)))
                         
               })
    
    }
    var googleSignInButton: some View {
        Button(action: {
            Task {
                await authvm.signInWithGoogle()
            }
        }) {
            HStack {
                Image(systemName: "arrow.up.right.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text("Sign in with Google")
                    .font(.headline)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }

    var emailtextfield: some View{
        TextField("", text: $email)
        .foregroundColor(.black)
        .font(.system(size: 17, weight: .semibold))
           
    }
    var passwordtextfield: some View{
        SecureField("",text: $password)
            .foregroundColor(.black)
            
           
    }
       
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
