//
//  LocationPermissionsViewController.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/25/22.
//

import UIKit

final class LocationPermissionsViewController: UIViewController {
    
    public weak var coordinator: Coordinator?
    
    private lazy var allowLocationButton = createLocationButton()
    private lazy var locationPermissionsInfoLabel = createLocationPermissionsInfoLabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        view.addSubview(allowLocationButton)
        view.addSubview(locationPermissionsInfoLabel)
        configureUserInterfaceConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userDeniedLocation = coordinator?.locationServicesInteractor?.userDeniedLocation ?? false
        
        if userDeniedLocation {
            configureWithReenableLocationMessage()
        } else {
            configureWithDefaultLocationMessage()
        }
    }
    
    public func configureWithDefaultLocationMessage() {
        locationPermissionsInfoLabel.text = "In order to stream nearby images from Flickr, komoot needs access your device's GPS"
    }
    
    public func configureWithReenableLocationMessage() {
        locationPermissionsInfoLabel.text = "In order for the app to function properly, you need to reenable Location Services from Settings"
    }
}

private extension LocationPermissionsViewController {
    
    private func createLocationButton() -> UIButton {
        let button = UIButton(type: .system)
        
        button.setTitle("Allow Location", for: .normal)
        button.addTarget(
            self,
            action: #selector(onAllowLocationButtonTap),
            for: .touchUpInside
        )
        
        return button
    }
    
    private func createLocationPermissionsInfoLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }
        
    private func configureUserInterfaceConstraints() {
        allowLocationButton.translatesAutoresizingMaskIntoConstraints = false
        locationPermissionsInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Button configuration
            allowLocationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            allowLocationButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            allowLocationButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            allowLocationButton.heightAnchor.constraint(equalToConstant: 44),
            // Label configuration
            locationPermissionsInfoLabel.topAnchor.constraint(equalTo: allowLocationButton.bottomAnchor, constant: 20),
            locationPermissionsInfoLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            locationPermissionsInfoLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
        ])
    }

    @objc
    private func onAllowLocationButtonTap() {
        guard let coordinator = coordinator?.locationServicesInteractor else { return }
        
        coordinator.requestUserLocationPermission()
    }
}
