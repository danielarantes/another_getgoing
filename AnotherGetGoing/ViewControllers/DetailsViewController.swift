//
//  DetailsViewController.swift
//  AnotherGetGoing
//
//  Created by Alla Bondarenko on 2018-06-20.
//  Copyright © 2018 Alla Bondarenko. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    var poi: PlaceOfInterest!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapViewCoordinate()
        photoImageView.downloadedFrom(url: Constants.getUrl(photoReference: poi.photoReference!))
    }

    func setMapViewCoordinate(){
        
        mapView.delegate = self
        
        if let coordinate = poi.location?.coordinate {
            //constructing the Annotation view (pin with the title) on the map
            let annotation = MKPointAnnotation()

            annotation.title = poi?.name
            annotation.coordinate.latitude = coordinate.latitude
            annotation.coordinate.longitude =  coordinate.longitude
            mapView.addAnnotation(annotation)

            //centering map camera on the point
            centerMapOnLocation(annotation.coordinate)
            
            //indicator in blue of user's current location if allowed by the user.
            mapView.showsUserLocation = true
            
            if let placeId = poi.place_id {
                GooglePlacesAPI.details(placeId: placeId, completionHandler: {(status, json) in
                    if let jsonObj = json {
                        if let value = APIParser.parserDetails(json: jsonObj) {
                            
                            
                            if let phone = value.phoneNumber, let website = value.website {
                                self.addressLabel.text = "\(phone)\n\(website)"
                            }
                        }
                    }
                })
            }
        }
    }
    
    func centerMapOnLocation(_ location: CLLocationCoordinate2D) {
        let radius = 5000
        let region = MKCoordinateRegionMakeWithDistance(location, CLLocationDistance(Double(radius) * 2.0), CLLocationDistance(Double(radius) * 2.0))
        
        //set the camera on the mapview to cover 5000 radius aroung the point (like a zoom level)
        mapView.setRegion(region, animated: true)
    }
}

extension DetailsViewController : MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            //if user's current location (blue dot), ignore
            if annotation.isKind(of: MKUserLocation.self) {
                return nil
            }

            //otherwise, customizing pin on the map for a given l=point.
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "reusePin")

            //allowing to show extra information in the pin view
            view.canShowCallout = true

            //"i" button
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            view.pinTintColor = UIColor.blue
    
            return view
        }
    
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            //accessory (by default - "i" button on your annotation view.
            let location = view.annotation

            //preparation for a mode in Apple Maps
            let launchingOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
            if let coordinate = view.annotation?.coordinate {
                //open apple maps with the required coordinate and launching options - walking mode
                let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = "\(self.poi.name)"
                mapItem.openInMaps(launchOptions: launchingOptions)
            }
        }
}
