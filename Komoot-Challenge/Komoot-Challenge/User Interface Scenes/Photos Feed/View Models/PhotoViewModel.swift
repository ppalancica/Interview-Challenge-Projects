//
//  PhotoViewModel.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/25/22.
//

import Foundation

public protocol PhotoViewModelType {
    var imageData: Data { get }
}

public struct PhotoViewModel: PhotoViewModelType {
    
    public private(set) var imageData: Data
    
    init(imageData: Data) {
        self.imageData = imageData
    }
}
