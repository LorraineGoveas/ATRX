//
//  MasterViewController.swift
//  CSC690Final
//
//  Created by Abigail Chin on 3/31/18.
//  Copyright © 2018 Abigail Chin. All rights reserved.
//

import UIKit
import GoogleMaps
import Hue

class AttractionsViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var filteredObjects = [Place]()
    let searchController = UISearchController(searchResultsController: nil)
    var places: [Place] = []
    var currentCityName: String?
    
    var isLoading = false
    var response : QNearbyPlacesResponse?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        setupSearchController()
        applyGradient()
        loadPlaces(true)
    }

    func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barStyle = .black

        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let place = places[indexPath.row]
                print("TEST PLACE DETAILS:", place.name );
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.placeItem = place
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    func canLoadMore() -> Bool {
        if isLoading {
            return false
        }
        
        if let response = self.response {
            if (!response.canLoadMore()) {
                return false
            }
        }
        
        return true
    }
    
    func loadPlaces(_ force:Bool) {
        
        if !force {
            if !canLoadMore() {
                return
            }
        }
        
        print("load more")
        isLoading = true
        PlaceController.getPlaces(place: currentCityName!, completion: didReceiveResponse)
    }
    
    func didReceiveResponse(response:QNearbyPlacesResponse?) -> Void {
        self.response = response
        if response?.status == "OK" {
            
            if let p = response?.places {
                places.append(contentsOf: p)
            }
            
            self.tableView?.reloadData()
        } else {
            let alert = UIAlertController.init(title: "Error", message: "Unable to fetch nearby places", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction.init(title: "Retry", style: .default, handler: { (action) in
                self.loadPlaces(true)
            }))
            present(alert, animated: true, completion: nil)
        }
        isLoading = false
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            return filteredObjects.count
        }else{
            return places.count
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AttractionCell
        let place: Place?
        
    
        
        if isFiltering(){
            place = filteredObjects[indexPath.row] as Place
        }else{
            place = places[indexPath.row] as Place
        }
        
        cell.label.text = place?.name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredObjects = places.filter({(($0.name as! String).description).contains(searchText)})
        tableView.reloadData()
    }
}

extension AttractionsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension AttractionsViewController{
    func applyGradient(){
        let gradient: CAGradientLayer = [UIColor(hex:"#49a09d"),UIColor(hex:"#5f2c82")].gradient{ gradient in
            gradient.locations = [0.5, 1.0]
            return gradient
        }
        gradient.frame = tableView.bounds
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradient, at: 0)
        tableView.backgroundView = backgroundView
    }
}


