//
//  SearchViewController.swift
//  AnotherGetGoing
//
//  Created by Alla Bondarenko on 2018-06-13.
//  Copyright © 2018 Alla Bondarenko. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    
    var rank = "Prominence"
    var distance = "25000"
    var openNow = false
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchParameterTextField: UITextField!
    var currentLocation: CLLocation?
    
    var searchParam: String?
    
    //MARK: - View Controller LifeCycle Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchParameterTextField.delegate = self
    }
    
    @IBAction func filterAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Button Actions
    @IBAction func searchButtonAction(_ sender: UIButton) {
        print("chooo chooo button")
        if segmentedControl.selectedSegmentIndex == 0 {
            searchParameterTextField.resignFirstResponder()
            if let inputValue = searchParam {
                GooglePlacesAPI.textSearch(query: inputValue,rank: rank, distance: distance, open: openNow, completionHandler: {(status, json) in
                    if let jsonObj = json {
                        let places = APIParser.parseAPIResponse(json: jsonObj)
                        //update UI on the main thread!
                        DispatchQueue.main.async {
                            if places.count > 0 {
                                self.presentSearchResults(places)
                            } else {
                                self.generalAlert(title: "Oops", message: "No results found")
                            }
                        }
                        print("\(places.count)")
                    } else {
                        self.generalAlert(title: "Oops", message: "An error parsing json")
                    }
                })
                
            } else {
                generalAlert(title: "Oops", message: "An error has occurred")
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            searchParameterTextField.resignFirstResponder()
            
            guard let currentLocation = currentLocation
                else {
                    return
            }
            if let inputValue = searchParam {
                GooglePlacesAPI.locationSearch(lat: currentLocation.coordinate.latitude, lng: currentLocation.coordinate.longitude, rank: rank, distance: distance, open: openNow, completionHandler: {(status, json) in
                    if let jsonObj = json {
                        let places = APIParser.parseAPIResponse(json: jsonObj)
                        //update UI on the main thread!
                        DispatchQueue.main.async {
                            if places.count > 0 {
                                self.presentSearchResults(places)
                            } else {
                                self.generalAlert(title: "Oops", message: "No results found")
                            }
                        }
                        print("\(places.count)")
                    } else {
                        self.generalAlert(title: "Oops", message: "An error parsing json")
                    }
                })
                
            } else {
                generalAlert(title: "Oops", message: "An error has occurred")
            }
        }
    }
    
    @IBAction func searchSelectionChanged(_ sender: UISegmentedControl) {
        print("segment control changed \(segmentedControl.selectedSegmentIndex)")
        if segmentedControl.selectedSegmentIndex == 1 {
            LocationService.sharedInstance.delegate = self
            LocationService.sharedInstance.startUpdatingLocation()
        }
    }
    
    func presentSearchResults(_ results: [PlaceOfInterest]){
        
        let searchResultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        searchResultsViewController.places = results
        
        navigationController?.pushViewController(searchResultsViewController, animated: true)
        
    }
    
    
    func generalAlert(title: String, message: String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        
        present(alertController, animated: true) {
            self.searchParameterTextField.placeholder = "Input something"
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


//MARK: - Text Field Delegate
extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchParameterTextField {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == searchParameterTextField {
            searchParam = textField.text
            print(textField.text ?? "no input")
        }
        return true
    }
    
}

//MARK: - Location Service Delegate

extension SearchViewController: LocationServiceDelegate {
    func tracingLocation(_ currentLocation: CLLocation) {
        self.currentLocation = currentLocation
        print("\(currentLocation.coordinate.latitude) \(currentLocation.coordinate.longitude)")
    }
    
    func tracingLocationDidFailWithError(_ error: Error) {
        
    }
    
}

extension SearchViewController: FilterDelegate {
    func getItems(rankBy: String, distance: String, openNow: Bool) {
        self.rank = rankBy
        self.distance  = distance
        self.openNow = openNow
    }
}

