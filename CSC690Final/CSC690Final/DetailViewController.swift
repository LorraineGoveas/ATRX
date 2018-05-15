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
import Hue

class DetailViewController: UIViewController {


    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var placePhoneNumberLabel: UILabel!
    
    var placeItem: Place?
    var isLoading = false
    
    func configureView() {
        if let place = placeItem{
            PlaceController.getPlaceDetails(place: place, completion: didReceiveResponse)
        }
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
        setUpGradient(top: UIColor(hex:"#5f2c82"),bottom: UIColor(hex:"#49a09d"))
        colorIcons()
        setupClickableLabels()
    }
    
    func setupClickableLabels(){
        let addressTap = UITapGestureRecognizer(target: self, action: #selector(directions))
        placeAddressLabel.addGestureRecognizer(addressTap)
        
        let phoneTap = UITapGestureRecognizer(target: self, action: #selector(callPhone))
        placePhoneNumberLabel.addGestureRecognizer(phoneTap)
        
    }
    
    func colorIcons(){
        phoneIcon.image = phoneIcon.image!.withRenderingMode(.alwaysTemplate)
        phoneIcon.tintColor = UIColor.white
        
        locationIcon.image = locationIcon.image!.withRenderingMode(.alwaysTemplate)
        locationIcon.tintColor = UIColor.white
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func callPhone(sender: UITapGestureRecognizer){
        
        let formattedPhoneNumber: String? = placePhoneNumberLabel.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    
        
        if let phoneCallURL:URL = URL(string: "tel://\(formattedPhoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                let alertController = UIAlertController(title: "MyApp", message: "Are you sure you want to call \n\(formattedPhoneNumber)?", preferredStyle: .alert)
                let yesPressed = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                })
                let noPressed = UIAlertAction(title: "No", style: .default, handler: { (action) in
                    
                })
                alertController.addAction(yesPressed)
                alertController.addAction(noPressed)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func directions(sender: UITapGestureRecognizer) {
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

