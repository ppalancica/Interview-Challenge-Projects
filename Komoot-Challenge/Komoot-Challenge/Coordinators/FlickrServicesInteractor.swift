//
//  FlickrServicesInteractor.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/26/22.
//

import Foundation

public protocol FlickrServicesInteractorType {
    
    var flickrAPIService: FlickrAPIServiceType { get }
    
    init(flickrAPIService: FlickrAPIServiceType)
    
    func downloadImageTakenNearby(userLocation: KomootUserLocation,
                                  completion: @escaping (Result<Data, FlickrError>) -> Void)
}

public class FlickrServicesInteractor: FlickrServicesInteractorType {
    
    public private(set) var flickrAPIService: FlickrAPIServiceType
    
    public required init(flickrAPIService: FlickrAPIServiceType) {
        self.flickrAPIService = flickrAPIService
    }
    
    public func downloadImageTakenNearby(userLocation: KomootUserLocation,
                                         completion: @escaping (Result<Data, FlickrError>) -> Void) {
        
        flickrAPIService.downloadFlickerImage(userLocation: userLocation) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let flickrError):
                completion(.failure(flickrError))
            }
        }
    }
}
