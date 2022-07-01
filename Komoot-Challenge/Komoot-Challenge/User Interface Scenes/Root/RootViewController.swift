//
//  RootViewController.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/25/22.
//

import UIKit

final class RootViewController: UIViewController {
    
    public weak var coordinator: Coordinator?
    
    private let photosViewController = PhotosViewController()
    private let locationPermissionsVC = LocationPermissionsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userAllowedLocation = coordinator?.locationServicesInteractor?.userAllowedLocation ?? false
        
        if userAllowedLocation {
            showPhotosViewController()
        } else {
            showLocationPermissionsViewController()
        }
    }
}

private extension RootViewController {
    
    private func showPhotosViewController() {
        photosViewController.coordinator = coordinator
        if let mainCoordinator = coordinator as? MainCoordinator {
            photosViewController.viewModel = mainCoordinator.photoListViewModel
        }
        
        navigationController?.pushViewController(photosViewController, animated: false)
    }
    
    private func showLocationPermissionsViewController() {
        locationPermissionsVC.coordinator = coordinator
        locationPermissionsVC.modalPresentationStyle = .fullScreen
        
        let userDeniedLocation = coordinator?.locationServicesInteractor?.userDeniedLocation ?? false
        
        if userDeniedLocation {
            locationPermissionsVC.configureWithReenableLocationMessage()
        } else {
            locationPermissionsVC.configureWithDefaultLocationMessage()
        }
        
        navigationController?.present(locationPermissionsVC, animated: false)
    }
}
