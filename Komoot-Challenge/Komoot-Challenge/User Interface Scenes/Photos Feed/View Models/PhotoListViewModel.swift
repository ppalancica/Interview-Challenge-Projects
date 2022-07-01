//
//  PhotoListViewModel.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/25/22.
//

import Foundation

public protocol PhotoListViewModelType {
    
    var numberOfImages: Int { get }
    
    mutating func append(viewModel: PhotoViewModelType)
    mutating func prepend(viewModel: PhotoViewModelType)
    
    func photoViewModelAt(index: Int) -> PhotoViewModelType
}

public struct PhotoListViewModel: PhotoListViewModelType {
    
    public private(set) var viewModels: [PhotoViewModelType]
    
    public var numberOfImages: Int {
        return viewModels.count
    }
    
    init(viewModels: [PhotoViewModelType] = []) {
        self.viewModels = viewModels
    }
    
    public mutating func append(viewModel: PhotoViewModelType) {
        viewModels.append(viewModel)
    }
    
    public mutating func prepend(viewModel: PhotoViewModelType) {
        viewModels.insert(viewModel, at: 0)
    }
    
    public func photoViewModelAt(index: Int) -> PhotoViewModelType {
        guard index >= 0 && index < viewModels.count else {
            fatalError("App got into an inconsistent state. UI and Data might be out of sync, or some other outside issues.")
        }
        return viewModels[index]
    }
}
