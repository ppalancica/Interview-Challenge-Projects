//
//  LocationServicesInteractor.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/26/22.
//

import Foundation

public protocol LocationServicesInteractorType {
    
    init(komootLocationService: KomootLocationServiceType,
         onUserLocationChange: ((KomootUserLocation) -> Void)?)
    
    var userDeniedLocation: Bool { get }
    var userAllowedLocation: Bool { get }
    
    func requestUserLocationPermission()
    func startUpdatingUserLocation()
    func stopUpdatingUserLocation()
    
    var komootLocationService: KomootLocationServiceType { get }
    var onUserLocationChange: ((KomootUserLocation) -> Void)? { get set }
}

public class LocationServicesInteractor: LocationServicesInteractorType {
    
    public private(set) var komootLocationService: KomootLocationServiceType
    public var onUserLocationChange: ((KomootUserLocation) -> Void)?
    
    public required init(komootLocationService: KomootLocationServiceType,
                         onUserLocationChange: ((KomootUserLocation) -> Void)?) {
        self.komootLocationService = komootLocationService
        self.onUserLocationChange = onUserLocationChange
    }
    
    public var userDeniedLocation: Bool {
        return komootLocationService.userDeniedLocation
    }
    
    public var userAllowedLocation: Bool {
        return komootLocationService.userAllowedLocation
    }
    
    public func startUpdatingUserLocation() {
        guard komootLocationService.userAllowedLocation else {
            print("Seems that Location Services were disabled fot this app while using it.")
            // Maybe display an UI Alert as well
            return
        }
        
        komootLocationService.onUserLocationChange = { [weak self] userLocation in
            self?.onUserLocationChange?(userLocation)
        }
        
        komootLocationService.startUpdatingUserLocation()
    }
    
    public func stopUpdatingUserLocation() {
        komootLocationService.stopUpdatingUserLocation()
    }
    
    public func requestUserLocationPermission() {
        komootLocationService.requestUserLocationPermission()
    }
}
