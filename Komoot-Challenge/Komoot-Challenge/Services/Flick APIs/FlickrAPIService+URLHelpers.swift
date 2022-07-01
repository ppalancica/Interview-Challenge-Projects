//
//  FlickrAPIService+URLHelpers.swift
//  Komoot-Challenge
//
//  Created by Pavel Palancica on 6/26/22.
//

import Foundation

public extension FlickrAPIService {
    
    class URLHelpers {
        
        public static func flickrPhotoSearchURL(location: KomootUserLocation) -> URL? {
            var components = URLComponents(string: FlickrAPIQueryValues.flickrBaseURL)
            components?.queryItems = urlQueryItems(location: location)
            
            guard let url = components?.url else {
                print("Problem building the URL for Flickr Photo Search")
                return nil
            }
            
            return url
        }
        
        public static func firstFlickrPhotoURL(from json: FlickrJSONDictionary) -> URL? {
            guard let flickrPhotoItem = json.photos.photo.first else { return nil }
            guard let url = URL(string: flickrPhotoURLString(for: flickrPhotoItem)) else { return nil }
            
            return url
        }
    }
}

private extension FlickrAPIService.URLHelpers {
    
    private static func urlQueryItems(location: KomootUserLocation) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        queryItems.append(URLQueryItem(
            name: FlickrAPIQueryParameters.flickrAPIMethod.asString(),
            value: FlickrAPIQueryValues.flickrAPIMethod
        ))
        
        queryItems.append(URLQueryItem(
            name: FlickrAPIQueryParameters.flickrAPIKey.asString(),
            value: FlickrAPIQueryValues.flickrAPIKey
        ))
                
        queryItems.append(URLQueryItem(
            name: FlickrAPIQueryParameters.flickrAPILatitude.asString(),
            value: "\(location.latitude)"
        ))
        
        queryItems.append(URLQueryItem(
            name: FlickrAPIQueryParameters.flickrAPILongitude.asString(),
            value: "\(location.longitude)"
        ))
        
        queryItems.append(URLQueryItem(
            name: FlickrAPIQueryParameters.flickrAPIFormatKey.asString(),
            value: FlickrAPIQueryValues.flickrAPIJsonFormat
        ))
        
        queryItems.append(URLQueryItem(
            name: FlickrAPIQueryParameters.flickrAPIJsonCallBack.asString(),
            value: FlickrAPIQueryValues.flickrAPIJsonCallBack
        ))
        
        queryItems.append(URLQueryItem(
            name: FlickrAPIQueryParameters.flickrAPIPhotosPerPage.asString(),
            value: "\(FlickrAPIQueryValues.flickrAPIPhotosPerPage)"
        ))
        
        queryItems.append(URLQueryItem(
            name: FlickrAPIQueryParameters.flickrAPIRadius.asString(),
            value: "\(FlickrAPIQueryValues.flickrAPIRadius)"
        ))
        
        return queryItems
    }
    
    private static func flickrPhotoURLString(for photoItem: FlickrPhotoItem) -> String {
        let subdomain = "farm\(photoItem.farm)"
        let domain = "staticflickr.com"
        let server = photoItem.server
        let imageName = photoItem.id + "_" + photoItem.secret + ".jpg"
        let urlString = "https://" + subdomain + "." + domain + "/" + server + "/" + imageName
        
        return urlString
    }
}
