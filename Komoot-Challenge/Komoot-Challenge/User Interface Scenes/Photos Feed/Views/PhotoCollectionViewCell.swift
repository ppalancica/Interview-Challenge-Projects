//
//  PhotoCollectionViewCell.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/25/22.
//

import UIKit

public class PhotoCollectionViewCell: UICollectionViewCell {
    
    private lazy var locationImageView: UIImageView = createLocationImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        contentView.addSubview(locationImageView)
        configureUserInterfaceConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLocationImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    private func configureUserInterfaceConstraints() {
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            locationImageView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor),
            locationImageView.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor),
            locationImageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    public func configureWith(viewModel: PhotoViewModelType) {
        if let image = UIImage(data: viewModel.imageData) {
            locationImageView.image = image
        }
    }
}
