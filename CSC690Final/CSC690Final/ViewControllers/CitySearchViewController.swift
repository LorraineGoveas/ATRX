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
    
    @IBOutlet weak var citySearchTitle: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    var citySearchCoordinate: CLLocationCoordinate2D?
    var currentCityName: String?
   
   
    
    @IBAction func clickedTitle(_ sender: Any) {
        if(citySearchTitle.currentTitle != "ATRX"){
            self.performSegue(withIdentifier: "chosenCitySegue", sender: nil)
        }
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
       
        if Auth.auth().currentUser != nil{ // logout
            do{
                try? Auth.auth().signOut()
                let alert = UIAlertController(title: "Success!", message: "You Logged Out", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cool", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                loginButton.setTitle("Login", for: .normal)
            }
        }else{ // login
            let authUI = FUIAuth.defaultAuthUI()
            authUI?.delegate = self as? FUIAuthDelegate
            authUI?.providers = [FUIGoogleAuth()]
            let authViewController = authUI!.authViewController()
            self.present(authViewController, animated: true, completion: nil)
            loginButton.setTitle("Logout", for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpGradient(top: UIColor(hex:"#5f2c82"), bottom: UIColor(hex:"#49a09d"))
        
        if Auth.auth().currentUser != nil{
            loginButton.setTitle("Logout", for: .normal)
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
        self.citySearchTitle.setTitle(place.name, for: .normal)
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

extension UIViewController{
    
    func setUpGradient(top topColor: UIColor,bottom bottomColor: UIColor){
        
        let gradient: CAGradientLayer = [topColor,bottomColor].gradient{ gradient in
            gradient.locations = [0.1, 1.0]
            return gradient
        }
        
        gradient.frame = view.frame
        view.layer.insertSublayer(gradient, at: 0)
    }
}

