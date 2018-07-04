//
//  PlaceOfInterest.swift
//  AnotherGetGoing
//
//  Created by Alla Bondarenko on 2018-06-18.
//  Copyright © 2018 Alla Bondarenko. All rights reserved.
//

import Foundation
import CoreLocation

class PlaceOfInterest {
    
    var id: String
    var name: String
    var rating: Double?
    var place_id: String?
    var location: CLLocation?
    var formattedAddress: String?
    var iconUrl: String?
    var photoReference: String?
    
    init?(json: [String: Any]){
        
        guard let id = json["id"] as? String else {
            return nil
        }
        guard let name = json["name"] as? String else {
            return nil
        }
        self.id = id
        self.name = name
        self.place_id = json["place_id"] as? String
        if let value = json["rating"] as? Double {
            self.rating = value
        } else {
            self.rating = 0
        }
        
        self.formattedAddress = json["formatted_address"] as? String
        self.iconUrl = json["icon"] as? String
        
        if let image = json["photos"] as? [[String: Any]] {
            self.photoReference = image[0]["photo_reference"] as? String
        }
        if let geometry = json["geometry"] as? [String: Any] {
            if let locationCoordinate = geometry["location"] as? [String: Double
                ] {
                if locationCoordinate["lat"] != nil, locationCoordinate["lng"] != nil {
                    self.location = CLLocation(latitude: locationCoordinate["lat"]!, longitude: locationCoordinate["lng"]!)
                }
            }
        }
    }
}

class Details: NSObject {
    var phoneNumber: String?
    var website: String?
    
    init?(json: [String: Any]){
        self.phoneNumber = json["formatted_phone_number"] as? String
        self.website = json["website"] as? String
    }
}
