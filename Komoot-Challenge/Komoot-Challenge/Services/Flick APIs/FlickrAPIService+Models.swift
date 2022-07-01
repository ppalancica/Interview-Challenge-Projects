//
//  FlickrAPIService+Models.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/26/22.
//

import Foundation

public struct FlickrJSONDictionary: Codable {
    public let photos: FlickrPhotos
    public let stat: String
}

public struct FlickrPhotos: Codable {
    public let photo: [FlickrPhotoItem]
}

public struct FlickrPhotoItem: Codable {
    public let id: String
    public let secret: String
    public let server: String
    public let farm: Int
}
