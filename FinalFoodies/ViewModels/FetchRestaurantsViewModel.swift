//
//  FetchRestaurantsViewModel.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 3/13/22.
//

import Foundation


// create fetcher for view model to pass to view
    class RestaurantFetcher: ObservableObject {
        
        @Published var restaurants : [Restaurant] = []
        //@Published var isLoading: Bool = false
        @Published var errorMessage: String? = nil
        
        let service: FetchAPI
        
        
        init(service: FetchAPI = NetworkManager()) {
            self.service = service
            fetchAllRestaurants()
        }
        func fetchAllRestaurants() {
           
            errorMessage = nil
            
            let endpoint = FoodiezAPI.getRestaurants
            
            print("scheme = \(endpoint.scheme)")
            print("url = \(endpoint.baseURL)")
          //  print("parameter = \(endpoint.parameters)")
            
//            service.request(endpoint: endpoint) { result in
//                print("result = \(result)")
//            }
            service.request(endpoint: endpoint) {
                [weak self] result in

                DispatchQueue.main.async {

                    switch result {
                    case.failure(let error):
                        self?.errorMessage = error.localizedDescription
                        print(error)
                    case.success(let restaurants):
                        print("success with \(restaurants.count)")
                        self?.restaurants = restaurants
                    }

                }

            }
        }

    }
//static func errorState() -> RestaurantFetcher {
//        let fetcher = RestaurantFetcher()
//    fetcher.errorMessage = error?.localizedDescription
//        return fetcher
//    }
//
//    static func successState() -> BreedFetcher {
//        let fetcher = BreedFetcher()
//        fetcher.breeds = [Breed.example1(), Breed.example2()]
//
//        return fetcher
//    }
//}

// Net we need to execute the http request and decode the json
// response is through a codable object in the model class I created
// parameters: would be the endpoint that we are making a request to and also completion will be the parsed respone form request by json conversion
// and object is returned is successful but and error is throwed if failed
   
