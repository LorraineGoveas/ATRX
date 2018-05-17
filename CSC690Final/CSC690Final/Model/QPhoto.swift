//
//  QPhoto.swift
//  CSC690Final
//
//  Created by Abigail Chin on 5/12/18.
//  Copyright © 2018 Abigail Chin. All rights reserved.
//

import Foundation
import UIKit

private let widthKey = "width"
private let heightKey = "height"
private let photoReferenceKey = "photo_reference"

class QPhoto: NSObject {
    
    var width: Int?
    var height: Int?
    var photoRef: String?
    
    init(photoInfo: [String:Any]) {
        height = photoInfo[heightKey] as? Int
        width = photoInfo[widthKey] as? Int
        photoRef = photoInfo[photoReferenceKey] as? String
    }
    
    func getPhotoURL(maxWidth:Int) -> URL? {
        if let ref = self.photoRef {
            return PlaceController.googlePhotoURL(photoReference: ref, maxWidth: maxWidth)
        }
        return nil
    }
}
