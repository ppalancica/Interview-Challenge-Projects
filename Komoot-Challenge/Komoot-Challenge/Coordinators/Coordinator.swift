//
//  Coordinator.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/25/22.
//

import UIKit

public protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get set }
    
    var locationServicesInteractor: LocationServicesInteractorType? { get set }
    var flickrServicesInteractor: FlickrServicesInteractorType? { get set }
    var photoStorageInteractor: PhotoStorageInteractorType? { get set }
    
    func start()
}
