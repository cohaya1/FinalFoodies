//
//  NoInternetPopup.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 1/18/24.
//

import SwiftUI


struct NoInternetPopup: View {
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)

            // Popup
            VStack {
                Text("No Internet Connection")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .frame(width: 300, height: 120)
            .cornerRadius(10)
        }
    }
}

#Preview {
    NoInternetPopup()
}
