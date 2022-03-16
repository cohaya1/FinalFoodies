//
//  FoodiezFeed.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 3/3/22.
//

import Foundation
import SwiftUI

// Create an enum so for diffent methods for http fucntionality to pass around other functions
enum StatusCodes:  Error {
    case success
    case failure
    
    var localizedDescription: String {
        switch self {
        case .success: return
            "200"
        case .failure: return
            "404 \(AlertView())"
        }
    }
}
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case update = "UPDATE"
    case delete = "DELETE"
    case put = "PUT"
    }
// Create enum for different scenarios if http method is HTTP or HTTPS

enum HTTPScheme: String {
    case http = "http"
    case https = "https"
}

// Create a protocol where the any endpoint we need to use can conform to
// The API protocol will help separate the tasks of constructing a URL
// For an API we need the scheme , paramaters, baseURL, path, meth
protocol API {
    
    var scheme: HTTPScheme{get}
   // var path: String {get}
    var baseURL: String {get}
    var parameters:[URLQueryItem] {get}
    var method: HTTPMethod{get}
}
protocol FetchAPI {
     func request(endpoint: API, completion: @escaping (Result<[Restaurant],StatusCodes>) -> Void)
}

enum FoodiezAPI: API {
    case getRestaurants
    
    var scheme: HTTPScheme{
        switch self {
        case .getRestaurants:
            return .https
        }
    }
//    var path: String {
//        switch self {
//        case .getRestaurants:
//            return "/api:zmetZ6cP/restaurants"
//        }
//    }
    
    var baseURL: String{
        switch self {
        case .getRestaurants:
            return "https://x8ki-letl-twmt.n7.xano.io/api:zmetZ6cP/restaurants"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case.getRestaurants:
            let params : [URLQueryItem] = []
                //[  URLQueryItem(name: "restaurants_id ", value: "restaurants_id ")]
            
//            if let query = query{
//                params.append(URLQueryItem(name: "keyword", value: query))
//            }
           return params
            
        }
    
       
    }
    
    var method: HTTPMethod {
        switch self {
        case .getRestaurants:
            return .get
        }
    }
}

struct NetworkManager: FetchAPI {
     func request(endpoint: API, completion: @escaping (Result<[Restaurant], StatusCodes>) -> Void) {
//        func buildURL(endpoint: API) -> URLComponents {
//          var components = URLComponents()
//          components.scheme = endpoint.scheme.rawValue
//          components.host = endpoint.baseURL
////          components.path = endpoint.path
////          components.queryItems = endpoint.parameters
//          return components
//
//      }
//
//       let components = buildURL(endpoint: endpoint)
//       guard let url = components.url else {
//           print("Url creation is returning \(StatusCodes.failure)")
//           return
//       }
       // create urlrequest variable
         //let url2 = "https://x8ki-letl-twmt.n7.xano.io/api:zmetZ6cP/restaurants"
         
//        var urlRequest = URLRequest(url: url)
//       // assign the httpmethod need for URlRequest function
//       urlRequest.httpMethod = endpoint.method.rawValue

         var urlRequest = URLRequest(url: URL(string: endpoint.baseURL)!)
         urlRequest.httpMethod = endpoint.method.rawValue
         urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
         
         
       let session = URLSession(configuration: .default)
       // create datatask closure with urlrequest as params to begin JSON Decoding of Restaurants
       let dataTask = session.dataTask(with: urlRequest) {
           data,  response, error in
           if let error = error {
               completion(.failure(StatusCodes.failure))
               print("Unknown Error", error)
               return
           }
           // if response is not empty then data will return
           guard response != nil, let data = data else {
               return
           }
           
           print("data = \(data)")
           do{
           let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
               print(json)
           }
           catch{
               
           }
           
           // if data returns then the reponse will be decoded into swift language based on model
           if let responseObject = try? JSONDecoder().decode([Restaurant].self, from: data){
               completion(.success(responseObject))
              // if any error then failure response will be invoked
           } else {
               let error = StatusCodes.failure
               completion(.failure(error))
           }
       }
       dataTask.resume()
   }
       
    }
    
    


    
   
    
   




//final class NetworkManager { // builds network layer for Url compoonents
//    private class func buildURL(endpoint: API) -> URLComponents {
//        var components = URLComponents()
//        components.scheme = endpoint.scheme.rawValue
//        components.host = endpoint.baseURL
//        components.path = endpoint.path
//        components.queryItems = endpoint.parameters
//        return components
//
//    }
    // Net we need to execute the http request and decode the json
    // response is through a codable object in the model class I created
    // parameters: would be the endpoint that we are making a request to and also completion will be the parsed respone form request by json conversion
    // and object is returned is successful but and error is throwed if failed
//    class func request(endpoint: API, completion: @escaping (Result<[Restaurant],StatusCodes>) -> Void) {
//        let components = buildURL(endpoint: endpoint)
//        guard let url = components.url else {
//            print("Url creation is returning \(StatusCodes.failure)")
//            return
//        }
//        // create urlrequest variable
//         var urlRequest = URLRequest(url: url)
//        // assign the httpmethod need for URlRequest function
//        urlRequest.httpMethod = endpoint.method.rawValue
//
//        let session = URLSession(configuration: .default)
//        // create datatask closure with urlrequest as params to begin JSON Decoding of Restaurants
//        let dataTask = session.dataTask(with: urlRequest) {
//            data,  response, error in
//            if let error = error {
//                completion(.failure(StatusCodes.failure))
//                print("Unknown Error", error)
//                return
//            }
//            // if response is not empty then data will return
//            guard response != nil, let data = data else {
//                return
//            }
//            // if data returns then the reponse will be decoded into swift language based on model
//            if let responseObject = try? JSONDecoder().decode([Restaurant].self, from: data){
//                completion(.success(responseObject))
//               // if any error then failure response will be invoked
//            } else {
//                let error = StatusCodes.failure
//                completion(.failure(error))
//            }
//        }
//        dataTask.resume()
//    }
//
//}

