//
//  PlacesController.swift
//  CSC690Final
//
//  Created by LIBEXTMAC on 5/11/18.
//  Copyright © 2018 Abigail Chin. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Alamofire

class PlacesController {
//    static func getCategories() -> [QCategory] {
//        let list:[QCategory] = ["Bakery", "Doctor", "School", "Taxi_stand", "Hair_care", "Restaurant", "Pharmacy", "Atm", "Gym", "Store", "Spa"]
//        return list
//    }
    
    static let searchApiHost = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    static let googlePhotosHost = "https://maps.googleapis.com/maps/api/place/photo"
    static let googlePlaceDetailsHost = "https://maps.googleapis.com/maps/api/place/details/json"
    
    static func getNearbyPlaces(by category:String, coordinates:CLLocationCoordinate2D, radius:Int, token: String?, completion: @escaping (NearbyPlacesResponse?) -> Void) {
        
        var params : [String : Any]
        
        if let t = token {
            params = [
                "key" : AppDelegate.googlePlacesAPIKey,
                "pagetoken" : t,
            ]
        } else {
            params = [
                "key" : AppDelegate.googlePlacesAPIKey,
                "radius" : radius,
                "location" : "\(coordinates.latitude),\(coordinates.longitude)",
                "type" : category.lowercased()
            ]
        }
        
        
        Alamofire.request(searchApiHost, parameters: params, encoding: URLEncoding(destination: .queryString)).responseJSON { response in
            
            let response = NearbyPlacesResponse.init(dic: response.result.value as? [String: Any])
            completion(response)
        }
    }
    
    static func getPlaceDetails(place:Place, completion: @escaping (Place) -> Void) {
        
        guard place.details == nil else {
            completion(place)
            return
        }
        
        var params : [String : Any]
        params = [
            "key" : AppDelegate.googlePlacesAPIKey,
            "placeid" : place.placeId,
        ]
        
        Alamofire.request(googlePlaceDetailsHost, parameters: params, encoding: URLEncoding(destination: .queryString)).responseJSON { response in
            let value = response.result.value as? [String : Any]
            place.details = (value)?["result"] as? [String : Any]
            completion(place)
        }
    }
    
//    static func googlePhotoURL(photoReference:String, maxWidth:Int) -> URL? {
//        return URL.init(string: "\(googlePhotosHost)?maxwidth=\(maxWidth)&key=\(AppDelegate.googlePlacesAPIKey)&photoreference=\(photoReference)")
//    }
}


struct NearbyPlacesResponse {
    var nextPageToken: String?
    var status: String  = "NOK"
    var places: [Place]?
    
    init?(dic:[String : Any]?) {
        nextPageToken = dic?["next_page_token"] as? String
        
        if let status = dic?["status"] as? String {
            self.status = status
        }
        
        if let results = dic?["results"] as? [[String : Any]]{
            var places = [Place]()
            for place in results {
                places.append(Place.init(placeInfo: place))
            }
            self.places = places
        }
    }
    
    func canLoadMore() -> Bool {
        if status == "OK" && nextPageToken != nil && nextPageToken?.characters.count ?? 0 > 0 {
            return true
        }
        return false
    }
}
