//
//  NearbyMapSearchViewModel.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 12/20/23.
//

import Foundation
import MapKit

class NearbySearchViewModel: ObservableObject {
    @Published var nearbyPlaces: [MKMapItem] = []

    func searchNearby(for category: String, region: MKCoordinateRegion) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = category
        request.region = region

        let search = MKLocalSearch(request: request)
        search.start { [weak self] (response, error) in
            guard let self = self, let response = response else { return }
            self.nearbyPlaces = response.mapItems
        }
    }
}
