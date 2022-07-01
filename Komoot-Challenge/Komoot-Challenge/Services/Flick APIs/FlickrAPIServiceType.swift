//
//  FlickrAPIServiceType.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/26/22.
//

import Foundation

public protocol FlickrAPIServiceType {
    
    func downloadFlickerImage(
        userLocation: KomootUserLocation,
        completion: @escaping (Result<Data, FlickrError>) -> Void
    )
}

public class FlickrError: Error { }
