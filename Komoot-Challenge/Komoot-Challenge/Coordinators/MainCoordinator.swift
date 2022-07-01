//
//  MainCoordinator.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/26/22.
//

import UIKit

public class MainCoordinator: Coordinator {
    
    // We'll inject this into the Photo Feed view controller
    public var photoListViewModel = PhotoListViewModel()
    
    public var navigationController: UINavigationController
    
    public var komootLocationService: KomootLocationServiceType
    public var flickrAPIService: FlickrAPIServiceType = FlickrAPIService()
    
    public var locationServicesInteractor: LocationServicesInteractorType?
    public var flickrServicesInteractor: FlickrServicesInteractorType?
    public var photoStorageInteractor: PhotoStorageInteractorType?
    
    public init(navigationController: UINavigationController,
                komootLocationService: KomootLocationServiceType,
                flickrAPIService: FlickrAPIServiceType,
                photoStorageInteractor: PhotoStorageInteractorType) {
        
        self.navigationController = navigationController
        self.komootLocationService = komootLocationService
        self.flickrAPIService = flickrAPIService
        self.photoStorageInteractor = photoStorageInteractor
        
        updateViewModelIfNeeded()
        
        self.komootLocationService.onUserGrantedLocation = { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
        
        self.komootLocationService.onUserDeniedLocation = {            
            guard let locationPermissionsViewController = navigationController.presentedViewController as? LocationPermissionsViewController else  {
                print("Presented View Controller should be of type \(String(describing: LocationPermissionsViewController.self))")
                return
            }
            
            locationPermissionsViewController.configureWithReenableLocationMessage()
        }
        
        self.locationServicesInteractor = LocationServicesInteractor(komootLocationService: self.komootLocationService, onUserLocationChange: { [weak self] userLocation in
            self?.downloadImageTakenNearby(userLocation: userLocation)
        })
    }
    
    public func start() {
        let rootVC = RootViewController()
        rootVC.coordinator = self
        navigationController.pushViewController(rootVC, animated: false)
    }
}

extension MainCoordinator {
    
    public func downloadImageTakenNearby(userLocation: KomootUserLocation) {
        flickrServicesInteractor = FlickrServicesInteractor(flickrAPIService: flickrAPIService)
        
        flickrServicesInteractor?.downloadImageTakenNearby(userLocation: userLocation,
                                                           completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.saveImageDataToPersistantStoreIfNeeded(with: data)
                    self?.updateUserInterfaceIfNeeded(with: data)
                case .failure(let flickrError):
                    print("There was some problem downloading Flickr image. Update UI stated if needed. Error: \(flickrError)")
                }
            }
        })
    }
        
    private func updateViewModelIfNeeded() {
        guard let photoStorageInteractor = photoStorageInteractor else { return }
        
        if photoStorageInteractor.numberOfItems > 0 {
            for index in 0..<photoStorageInteractor.numberOfItems {
                if let imageData = photoStorageInteractor.imageDataForItem(at: index) {                   
                    photoListViewModel.append(
                        viewModel: PhotoViewModel(imageData: imageData)
                    )
                }
            }
        }
    }
    
    private func saveImageDataToPersistantStoreIfNeeded(with data: Data) {
        photoStorageInteractor?.saveImageData(data: data)
    }
    
    private func updateUserInterfaceIfNeeded(with data: Data) {
        guard let photosViewController = navigationController.viewControllers.last as? PhotosViewController else {
            print("PhotosViewController is not visible at the moment.")
            return
        }
        
        let photoViewModel = PhotoViewModel(imageData: data)
        
        photoListViewModel.prepend(viewModel: photoViewModel)
        photosViewController.viewModel = photoListViewModel
    }
}
