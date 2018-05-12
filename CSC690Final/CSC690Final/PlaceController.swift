//
//  PlaceController.swift
//  CSC690Final
//
//  Created by Abigail Chin on 5/12/18.
//  Copyright © 2018 Abigail Chin. All rights reserved.
//

import Alamofire
import UIKit

class PlaceController{
    
    static let searchApiHost = "https://maps.googleapis.com/maps/api/place/textsearch/json"
    static let googlePhotosHost = "https://maps.googleapis.com/maps/api/place/photo"
    static let googlePlaceDetailsHost = "https://maps.googleapis.com/maps/api/place/details/json"

    static func getPlaces(place: String, completion: @escaping (QNearbyPlacesResponse?) -> Void) {
        
        var params : [String : Any]
        params = [
            "query" : formatPlaceName(for: place) + "+point+of+interest",
            "key" : AppDelegate.googlePlacesAPIKey,
        ]
        
        Alamofire.request(searchApiHost, parameters: params, encoding: URLEncoding(destination: .queryString)).responseJSON { response in
            let response = QNearbyPlacesResponse.init(dic: response.result.value as? [String: Any])
            completion(response)
        }
    
    }

    static func formatPlaceName(for placeName: String) -> String{
        return placeName.lowercased().replacingOccurrences(of: " ", with: "+")
    }
    
    
    static func getPlaceDetails(place: Place, completion: @escaping (Place) -> Void) {
        
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
    
    static func googlePhotoURL(photoReference:String, maxWidth:Int) -> URL? {
        return URL.init(string: "\(googlePhotosHost)?maxwidth=\(maxWidth)&key=\(AppDelegate.googlePlacesAPIKey)&photoreference=\(photoReference)")
    }
}

struct QNearbyPlacesResponse {
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
