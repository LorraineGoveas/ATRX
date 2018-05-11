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

class CitySearchViewController: UIViewController{
    
    @IBOutlet weak var citySearch: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
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
        if Auth.auth().currentUser != nil{
            loginButton.isHidden = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CitySearchViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.citySearch.text = place.name
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
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


