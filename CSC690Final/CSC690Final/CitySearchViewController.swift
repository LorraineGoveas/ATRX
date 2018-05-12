//
//  CitySearchViewController.swift
//  CSC690Final
//
//  Created by Abigail Chin on 4/14/18.
//  Copyright © 2018 Abigail Chin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseGoogleAuthUI
import FirebaseAuthUI
import GooglePlaces
import Hue

class CitySearchViewController: UIViewController{
    
    @IBOutlet weak var citySearch: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var citySearchCoordinate: CLLocationCoordinate2D?
    var currentCityName: String?
    
    let gradient: CAGradientLayer = [
        UIColor(hex:"#5f2c82"),
        UIColor(hex:"#49a09d")
    ].gradient()
    
    let gradient2: CAGradientLayer = [UIColor(hex:"#5f2c82"),UIColor(hex:"#49a09d")].gradient{ gradient in
        gradient.locations = [0.1, 1.0]
        return gradient
    }
    
    @IBAction func gpaButton(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self as? FUIAuthDelegate
        authUI?.providers = [FUIGoogleAuth()]
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient2.frame = view.frame
        view.layer.insertSublayer(gradient2, at: 0)
        
        if Auth.auth().currentUser != nil{
            loginButton.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let attractionViewController = segue.destination as? AttractionsViewController {
            //attractionViewController.cityCoordinates = self.citySearchCoordinate
            attractionViewController.currentCityName = self.currentCityName
        }
    }
    
}

extension CitySearchViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.citySearch.text = place.name
        currentCityName = place.name
        //citySearchCoordinate = place.coordinate
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "chosenCitySegue", sender: nil)
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}


