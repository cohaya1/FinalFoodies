//
//  DetailsPageViewModel.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 5/12/23.
//
import CoreLocation
import MapKit
import Foundation

protocol LocationService {
    func openMaps(with locationString: String)
    
}

struct AppleMapsService: LocationService {
    func openMaps(with locationString: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString) { placemarks, error in
            guard
                let placemark = placemarks?.first,
                let location = placemark.location else { return }
                
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
            mapItem.name = locationString
            mapItem.openInMaps(launchOptions: nil)
        }
    }
}


class DetailsPageViewModel: ObservableObject {
    private let locationService: LocationService
    
    init(locationService: LocationService = AppleMapsService()) {
        self.locationService = locationService
    }
    
    func goToLocation(_ location: String) {
        locationService.openMaps(with: location)
    }
}
