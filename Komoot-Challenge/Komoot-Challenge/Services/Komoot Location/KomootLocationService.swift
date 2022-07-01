//
//  KomootLocationService.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/25/22.
//

import Foundation
import CoreLocation

final class KomootLocationService: NSObject, KomootLocationServiceType, CLLocationManagerDelegate {
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    var latestLocation: CLLocation?
    
    public private(set) lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        
        manager.allowsBackgroundLocationUpdates = true
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        
        return manager
    }()
    
    override init() {
        super.init()
        
        authorizationStatus = userAuthorizationStatus()
                
        if authorizationStatus == .restricted || authorizationStatus == .denied {
            // Needs to go to Settings
        }
    }
    
    // Closure Properties declared inside KomootLocationManagerType protocol
    
    public var onUserDeniedLocation: (() -> Void)?
    public var onUserGrantedLocation: (() -> Void)?
    public var onUserLocationChange: ((KomootUserLocation) -> Void)?
}

// MARK: KomootLocationManagerType computed properties and methods

extension KomootLocationService {
    
    var userDeniedLocation: Bool {
        let status: CLAuthorizationStatus = userAuthorizationStatus()
        
        return status == .restricted || status == .denied
    }
    
    var userAllowedLocation: Bool {
        let status: CLAuthorizationStatus = userAuthorizationStatus()
        
        return status == .authorizedAlways
    }
    
    func requestUserLocationPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func startUpdatingUserLocation() {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingUserLocation() {
        locationManager.stopUpdatingLocation()
    }
}

private extension KomootLocationService {
    
    private func userAuthorizationStatus() -> CLAuthorizationStatus {
        let status: CLAuthorizationStatus
        
        if #available(iOS 14, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        return status
    }
}
