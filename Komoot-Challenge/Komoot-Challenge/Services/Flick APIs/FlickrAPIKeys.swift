//
//  FlickrAPIKeys.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/26/22.
//

import Foundation

// Number of Paramter Names to be used is known, therefore we can use an Enum
public enum FlickrAPIQueryParameters: String {
    
    case flickrAPIKey = "api_key"
    case flickrAPIMethod = "method"
    case flickrAPIFormatKey = "format"
    case flickrAPIJsonCallBack = "nojsoncallback"
    case flickrAPIPhotosPerPage = "per_page"
    case flickrAPILatitude = "lat"
    case flickrAPILongitude = "lon"
    case flickrAPIRadius = "radius"
    
    func asString() -> String {
        return rawValue
    }
}

// Parameter Values can be the same (in last 2 cases for instance)
// Therefore, we should use a Struct (cause an enum would be problematic in this situation)
public struct FlickrAPIQueryValues {
    
    static let flickrBaseURL = "https://api.flickr.com/services/rest/"
    static let flickrAPIKey = "d72db84dc54e8554a8672eb4faaaacab"
    static let flickrAPIMethod = "flickr.photos.search"
    static let flickrAPIJsonFormat = "json"
    static let flickrAPIJsonCallBack = "1"
    static let flickrAPIPhotosPerPage = "1"
    static let flickrAPIRadius = "0.1"
}
