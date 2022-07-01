//
//  KomootLocationService+CLLocationManagerDelegate.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/26/22.
//

import Foundation
import CoreLocation

// MARK: CLLocationManagerDelegate methods

extension KomootLocationService {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        
        let userLocation = KomootUserLocation(
            latitude: currentLocation.coordinate.latitude,
            longitude: currentLocation.coordinate.longitude
        )
        
        // check 100 meters change
        if let latestLocation = latestLocation {
            let distanceInMeters = currentLocation.distance(from: latestLocation)
            guard distanceInMeters >= 100 else { return }
        }
        
        latestLocation = currentLocation
        onUserLocationChange?(userLocation) // Whener user passed >= 100 meters from previous Photo Location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }

    //
    // Possible Cases:
    //
    //   .authorizedAlways, .authorizedWhenInUse, .restricted, .denied, .notDetermined
    //
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = locationManager.authorizationStatus
        handleLocationAuthorizationChange(status: authorizationStatus)
    }
    
    // For < iOS 14 backwards compatibility
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        handleLocationAuthorizationChange(status: authorizationStatus)
    }
}

private extension KomootLocationService {
    
    private func handleLocationAuthorizationChange(status: CLAuthorizationStatus) {
        if authorizationStatus == .authorizedAlways {
            onUserGrantedLocation?()
        } else if authorizationStatus == .restricted || authorizationStatus == .denied {
            onUserDeniedLocation?()
        }
    }
}
