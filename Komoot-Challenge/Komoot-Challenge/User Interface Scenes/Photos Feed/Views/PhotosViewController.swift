//
//  PhotosViewController.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/25/22.
//

import UIKit

class PhotosViewController: UIViewController {
    
    public weak var coordinator: Coordinator?
    
    public var viewModel: PhotoListViewModelType? {
        didSet {
            refreshUI()
        }
    }
    
    private lazy var photosCollectionView = createPhotosCollectionView()
    
    private var isUpdatingLocation = false {
        didSet {
            if isUpdatingLocation {
                navigationItem.rightBarButtonItem = createStopBarButtonItem()
            } else {
                navigationItem.rightBarButtonItem = createStartBarButtonItem()
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.hidesBackButton = true
        navigationItem.title = "Photos"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = createStartBarButtonItem()
        
        view.addSubview(photosCollectionView)
        configureUserInterfaceConstraints()
    }
}

private extension PhotosViewController {
    
    private func refreshUI() {
        photosCollectionView.reloadData()
    }
    
    private func createPhotosCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: PhotoCollectionViewCell.self)
        )
        
        return collectionView
    }
    
    private func configureUserInterfaceConstraints() {
        photosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photosCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            photosCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func createStartBarButtonItem() -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(
            title: "Start",
            style: .plain,
            target: self,
            action: #selector(onStartBarButtonTap)
        )
        
        return barButtonItem
    }
    
    private func createStopBarButtonItem() -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(
            title: "Stop",
            style: .plain,
            target: self,
            action: #selector(onStopBarButtonTap)
        )
        
        return barButtonItem
    }
    
    @objc
    private func onStartBarButtonTap() {
        guard let coordinator = coordinator?.locationServicesInteractor else { return }
        
        coordinator.startUpdatingUserLocation()
        isUpdatingLocation = true
    }
    
    @objc
    private func onStopBarButtonTap() {
        guard let coordinator = coordinator?.locationServicesInteractor else { return }
        
        coordinator.stopUpdatingUserLocation()
        isUpdatingLocation = false
    }
}

// MARK: UICollectionViewDataSource methods

extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        guard let viewModel = viewModel else { return 0 }
        
        return viewModel.numberOfImages
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // If PhotoListViewModel is not intialized, or a PhotoCollectionViewCell object cannot be dequeued:
        // - perhaps something is wrong with code that created the PhotosViewController instance,
        // and pushed it to the Navigation stack without properly injecting the dependencies
        guard let viewModel = viewModel, let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: PhotoCollectionViewCell.self),
            for: indexPath
        ) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
                
        let photoViewModel = viewModel.photoViewModelAt(index: indexPath.item)
        cell.configureWith(viewModel: photoViewModel)
        
        return cell
    }
}

// MARK: UICollectionViewDelegate methods

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let ratio = 0.75 // 3.0 divided by 4.0
        let padding = 16.0
        let width = UIScreen.main.bounds.size.width - padding * 2.0
        let height = width * ratio
        
        return CGSize(width: width, height: height)
    }
}
