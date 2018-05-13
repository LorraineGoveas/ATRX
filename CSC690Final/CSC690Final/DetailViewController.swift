//
//  DetailViewController.swift
//  CSC690Final
//
//  Created by Abigail Chin on 3/31/18.
//  Copyright © 2018 Abigail Chin. All rights reserved.
//

import UIKit
import MapKit
import AlamofireImage

class DetailViewController: UIViewController {


    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var placePhoneNumberLabel: UILabel!
    
    var placeItem: Place?
    var isLoading = false
    
    func configureView() {
        PlaceController.getPlaceDetails(place: placeItem!, completion: didReceiveResponse)
    }

    func didReceiveResponse(response: Place?) -> Void {
        placeNameLabel.text = response?.name
        placeAddressLabel.text = response?.address
        placePhoneNumberLabel.text = response?.phoneNumber
        
        if let image = response?.photos?.first?.getPhotoURL(maxWidth: 600) {
            placeImage.af_setImage(withURL: image)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func directionsButton(_ sender: Any) {
        
        let regionDistance: CLLocationDistance = 1000
        let regionSpan = MKCoordinateRegionMakeWithDistance((placeItem?.location)!, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placeMark = MKPlacemark(coordinate: (placeItem?.location)!)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = placeItem?.name
        mapItem.openInMaps(launchOptions: options)
    }
    
    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

