//
//  RestaurantTableItem.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 3/16/22.
//

import SwiftUI


//struct URlImage : View {
//
//    @StateObject var imageLoader: ImageLoaderViewModel
//    init(url: String?) {
//        self._imageLoader = StateObject(wrappedValue: ImageLoaderViewModel(url: url))
//    }
//    var body: some View {
//        if imageLoader.image != nil {
//            Image(uiImage : imageLoader.image!)
//                .resizable()
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
//                            .shadow(radius: 10)
//            .aspectRatio(contentMode: .fit)
//            .frame(width: 276.1, height: 183.1)
//            .clipped()
//        .frame(width: 276.1, height: 183.1)
//    }
//        else {
//            Image(" ")
//                .resizable()
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
//                            .shadow(radius: 10)
//            .aspectRatio(contentMode: .fill)
//            .frame(width: 276.1, height: 183.1)
//            .clipped()
//        .frame(width: 276.1, height: 183.1)
//        .onAppear(perform: imageLoader.fetchImageData)
//        }
//    }
//}

struct RestaurantTableItem: View {
    
    @State var restaurant:Restaurant
  
    var body: some View {
        ZStack {
           
            //Ellipse 2
           
            //Rectangle 9
          
            
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .frame(width: 220, height: 270)
            .shadow(color: Color(#colorLiteral(red: 0.22499999403953552, green: 0.22499999403953552, blue: 0.22499999403953552, alpha: 0.10000000149011612)), radius:60, x:0, y:30)
           
                
            //Ellipse 2
            // Composition groups need to live inside some a stack. (VStack, ZStack, or HStack)

            ZStack {
                
               
                Circle()
                .fill(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)))

                Circle()
                .strokeBorder(Color(#colorLiteral(red: 0.949999988079071, green: 0.949999988079071, blue: 0.949999988079071, alpha: 1)), lineWidth: 1)
                if let imageUrl = restaurant.restaurantimage?.url, let url = URL(string: imageUrl) {
                                    CacheAsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                                .shadow(radius: 10)
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 276.1, height: 183.1)
                                                .clipped()
                                                .frame(width: 276.1, height: 183.1)
                                        case .failure(_):
                                            // Handle failure, perhaps with an error placeholder image
                                            Image(systemName: "photo")
                                                .resizable()
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                                .shadow(radius: 10)
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 276.1, height: 183.1)
                                                .clipped()
                                                .frame(width: 276.1, height: 183.1)
                                        @unknown default:
                                            fatalError()
                                        }
                                    }
                                }
                            }
            
            .compositingGroup()
            .frame(width: 164.2, height: 174.2)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 4)), radius:4, x:0, y:4)
            .padding(.bottom,200)
            VStack(spacing: 25){
                Text(restaurant.restaurantname).font(.system(size: 22, weight: .semibold, design: .rounded)).multilineTextAlignment(.center)
                    .lineLimit(3)
                    .frame(width: 220, height: 70, alignment: .center)
                    .foregroundColor(Color(.black))
            //    Text(restaurant.restaurantstypeID).font(.system(size: 17, weight: .bold, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0.98, green: 0.29, blue: 0.05, alpha: 1))).multilineTextAlignment(.center)
                
                Text(String(format:"%.1f",restaurant.restaurantrating ?? " ")).font(.system(size: 17, weight: .bold, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0.98, green: 0.29, blue: 0.05, alpha: 1))).multilineTextAlignment(.center)
                
//                Text("N1,900").font(.system(size: 17, weight: .bold, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0.98, green: 0.29, blue: 0.05, alpha: 1))).multilineTextAlignment(.center)
           
            }.padding(.top,100)
        }
    }
}

//struct RestaurantTableItem_Previews: PreviewProvider {
//    static var previews: some View {
//        RestaurantTableItem(restaurant: Restaurant(0, 0, "", "", 0.0, "", 0,Double(0.0),Double(0.0), nil, Restaurantimage(path: "", name:"",type: .image, size: 0, mime: "", meta: Meta(width: 10, height: 10), url: "")))
//    }
//}
//
