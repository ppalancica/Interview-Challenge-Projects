//
//  KomootLocationServiceType.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/26/22.
//

import Foundation

public protocol KomootLocationServiceType {
    
    var userDeniedLocation: Bool { get }
    var userAllowedLocation: Bool { get }
    
    func requestUserLocationPermission()
    func startUpdatingUserLocation()
    func stopUpdatingUserLocation()
    
    var onUserDeniedLocation: (() -> Void)? { get set }
    var onUserGrantedLocation: (() -> Void)? { get set }
    var onUserLocationChange: ((KomootUserLocation) -> Void)? { get set }
}
