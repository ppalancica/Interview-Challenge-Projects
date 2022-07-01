//
//  FlickrAPIService.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/25/22.
//

import Foundation

public class FlickrAPIService: FlickrAPIServiceType {
    
    private let cache = NSCache<ImageURLWrapper, ImageDataWrapper>()
    
    // Data returned here can be something slightly different each time
    // No need to cache it
    public func downloadFlickerImage(userLocation: KomootUserLocation,
                                     completion: @escaping (Result<Data, FlickrError>) -> Void) {
        
        guard let url = URLHelpers.flickrPhotoSearchURL(location: userLocation) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, urlResponse, error in
            if let error = error {
                print("Error from Flickr API: \(error)")
                return
            }
            
            guard let urlResponse = urlResponse else {
                print("Problem: There was no URL Response from Flickr API")
                return
            }
            print("URL Response: \(urlResponse)")
            
            guard let data = data else {
                print("Problem: There was no data from Flickr API")
                return
            }
            
            guard let jsonDict = try? JSONDecoder().decode(FlickrJSONDictionary.self, from: data) else {
                print("Problem: Flickr API could not parsed to valid JSON")
                return
            }
            print("jsonDict from FlickrAPI: \(jsonDict)")
            
            self?.downloadLatestImage(from: jsonDict, completion: completion)
            
        }.resume()
    }
    
    private func downloadLatestImage(from json: FlickrJSONDictionary,
                                     completion: @escaping (Result<Data, FlickrError>) -> Void) {
        
        guard let photoURL = URLHelpers.firstFlickrPhotoURL(from: json) else { return }
        
        let cachedImageData = cachedImageDataForImageAt(url: photoURL)
        guard cachedImageData == nil else {
            completion(.success(cachedImageData!))
            return
        }
        
        URLSession.shared.dataTask(with: photoURL) { [weak self] data, urlResponse, error in
            if let error = error {
                print("Error from Flickr API: \(error)")
                return
            }
            
            guard let urlResponse = urlResponse else {
                print("Problem: There was no URL Response from Flickr API")
                return
            }
            print("URL Response: \(urlResponse)")
            
            guard let data = data else {
                print("Problem: There was no data from Flickr API")
                return
            }
            
            self?.addImageDataToCache(imageData: data, imageURL: photoURL)
            completion(.success(data))
            
        }.resume()
    }
}

// MARK: Caching related classes

private extension FlickrAPIService {
    
    final class ImageURLWrapper: NSObject {
        let url: URL
        
        init(url: URL) {
            self.url = url
        }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let other = object as? ImageURLWrapper else {
                return false
            }
            
            return url == other.url
        }

        override var hash: Int {
            return url.hashValue
        }
    }
        
    private class ImageDataWrapper {
        let data: Data
        
        init(imageData: Data) {
            self.data = imageData
        }
    }
    
    private func cachedImageDataForImageAt(url: URL) -> Data? {
        let imageURLWrapper = ImageURLWrapper(url: url)
        let imageDataWrapper = cache.object(forKey: imageURLWrapper)
        
        return imageDataWrapper?.data ?? nil
    }
    
    private func addImageDataToCache(imageData: Data, imageURL: URL) {
        let imageURLWrapper = ImageURLWrapper(url: imageURL) // Key
        let imageDataWrapper = ImageDataWrapper(imageData: imageData) // Value
        
        cache.setObject(imageDataWrapper, forKey: imageURLWrapper)
    }
}
