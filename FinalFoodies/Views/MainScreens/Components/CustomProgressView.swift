//
//  CustomProgressView.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 5/29/23.
//

import SwiftUI

struct CustomProgressView: View {
    @State private var isAnimating = false

    var body: some View {
        Image(systemName: "arrow.2.circlepath.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(Animation.linear(duration: 1.0).repeatForever(autoreverses: false))
            .onAppear {
                self.isAnimating = true
            }
            .foregroundColor(.red)
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView()
    }
}
