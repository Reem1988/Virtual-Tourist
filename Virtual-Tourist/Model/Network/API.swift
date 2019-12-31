//
//  API.swift
//  Virtual-Tourist
//
//   Created by Reem Alosaimi on 12/01/19.
//   Copyright © 2019 Reem Alosaimi. All rights reserved.
//


import Foundation

extension Flickr{
    
    
    // MARK: Constants
    struct Constants {
        static var APIKey = "e796a415a27fd1a964e716120e4d0dfa"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.flickr.com"
        static let ApiPath = "/services/rest"
    }
    
    // MARK: Methods
    struct Methods {
        // MARK: StudentLocation
        static let Search = "flickr.photos.search"
    }
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Extras = "extras"
        static let SafeSearch = "safe_search"
        static let Longitude = "lon"
        static let Latitude = "lat"
        static let Format = "format"
        static let NoJsonCallback = "nojsoncallback"
        static let PerPage = "per_page"
        static let Page = "page"
    }
    
    // MARK: Flickr Parameter Values
    struct FlickrParameterValues {
        static let MediumURL = "url_m"
        static let SquareURL = "url_q"
        static let UseSafeSearch = "1"
        static let Json = "json"
        static let JsonCallBackValue = "1"
        static let PerPageValue = "21"
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let MediumURL = "url_m"
        static let SquareURL = "url_q"
        static let Pages = "pages"
        static let Total = "total"
        
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
}
