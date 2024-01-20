//
//  DirectionsViewModel.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 12/20/23.
//

import Foundation
import MapKit

class DirectionsViewModel: ObservableObject {
    @Published var directions: [String] = []
    
    func calculateDirections(to restaurant: Restaurant, completion: @escaping () -> Void) {
        let destinationCoordinate = CLLocationCoordinate2D(latitude: restaurant.restaurantlatitude ?? 0, longitude: restaurant.restaurantlongitude ?? 0)
        
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.transportType = .automobile // Can be made dynamic based on user selection
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] (response, error) in
            DispatchQueue.main.async {
                if let route = response?.routes.first {
                    self?.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
                } else {
                    self?.directions = []
                }
                completion()
            }
        }
    }
}
