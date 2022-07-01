//
//  PhotoStorageInteractor.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/26/22.
//

import Foundation

public protocol PhotoStorageInteractorType {
    
    var numberOfItems: Int { get }
    
    func imageDataForItem(at index: Int) -> Data?
    func saveImageData(data: Data)
    func syncPhotoStorageMetadata()
}

public class PhotoStorageInteractor: PhotoStorageInteractorType {
    
    private let defaults = UserDefaults.standard
    private let savedImageItemsKey = "savedImageItems"
    private let imageNameKey = "imageName"
    
    // Contains the Images info, such as file names. Some other metadata can be added later.
    // The actual Image Data is saved in Documents directory.
    private var savedImageItems: [Dictionary<String, Any>] = []
    
    init() {
        savedImageItems = imageItemsSavedInUserDefaults()
    }
        
    public var numberOfItems: Int {
        return savedImageItems.count
    }
    
    public func imageDataForItem(at index: Int) -> Data? {
        guard !savedImageItems.isEmpty else { return nil }
        guard index >= 0 && index < savedImageItems.count else { return nil }
                
        let imageItem = savedImageItems[index]
        let imageName = (imageItem[imageNameKey] as? String) ?? ""
        let localImageURL = documentsDirectoryURL.appendingPathComponent(imageName)
        
        do {
            let imageData = try Data(contentsOf: localImageURL)
            return imageData
        } catch {
            print("Problems with getting Local Storage image data. Error: \(error)")
            return nil
        }
    }
    
    public func saveImageData(data: Data) {
        let currentTimeAsString = "\(Date().timeIntervalSince1970)"
        let imageName = "image_\(currentTimeAsString).jpg"
        let localImageURL = documentsDirectoryURL.appendingPathComponent(imageName)
        
        do {
            try data.write(to: localImageURL)
        } catch {
            print("Unable to write Image Data to Documents directory \(error)")
        }
        
        // Some more metadata could be added in the future
        let imageItem = [
            imageNameKey: imageName
        ]
        
        savedImageItems.insert(imageItem, at: 0)
        syncPhotoStorageMetadata()
    }
    
    // To be invoked from applicationWillResignActive or other suitable places
    // In production, something more performant could be used, such as SQLite or CoreData
    public func syncPhotoStorageMetadata() {
        defaults.setValue(savedImageItems, forKey: savedImageItemsKey)
    }
}

// MARK: Private methods

private extension PhotoStorageInteractor {
    
    private func imageItemsSavedInUserDefaults() -> [Dictionary<String, Any>] {
        guard let savedImageItems = defaults.object(forKey: savedImageItemsKey) as? [Dictionary<String, Any>] else {
            return []
        }
        return savedImageItems
    }
    
    private var documentsDirectoryURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
