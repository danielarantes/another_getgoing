//
//  GooglePlacesAPI.swift
//  AnotherGetGoing
//
//  Created by Alla Bondarenko on 2018-06-18.
//  Copyright © 2018 Alla Bondarenko. All rights reserved.
//

import Foundation

class GooglePlacesAPI {
    
    class func textSearch(query: String, completionHandler: @escaping(_ statusCode: Int, _ json: [String: Any]?) -> Void){
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.textPlaceSearch
        
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        
        NetworkingLayer.getRequest(with: urlComponents) { (statusCode, data) in
            if let jsonData = data,
                let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                print(jsonObject ?? "")
                completionHandler(statusCode, jsonObject)
            } else {
                print("life is not easy")
                completionHandler(statusCode, nil)
            }
        }
    }
    
    class func locationSearch(lat: Double, lng: Double, completionHandler: @escaping(_ statusCode: Int, _ json: [String: Any]?) -> Void){
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.locationSearch
        
        urlComponents.queryItems = [
            URLQueryItem(name: "location", value: "\(lat),\(lng)"),
            URLQueryItem(name: "radius", value: "1500"),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        print("location url \(urlComponents.url)")
        NetworkingLayer.getRequest(with: urlComponents) { (statusCode, data) in
            if let jsonData = data,
                let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                print(jsonObject ?? "")
                completionHandler(statusCode, jsonObject)
            } else {
                print("life is not easy")
                completionHandler(statusCode, nil)
            }
        }
    }

    class func details(placeId: String, completionHandler: @escaping(_ statusCode: Int, _ json: [String: Any]?) -> Void){
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.detailsPath
        
        urlComponents.queryItems = [
            URLQueryItem(name: "placeid", value: placeId),
            URLQueryItem(name: "fields", value: "formatted_phone_number,website"),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        print("place Details \(urlComponents.url)")
        NetworkingLayer.getRequest(with: urlComponents) { (statusCode, data) in
            if let jsonData = data,
                let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                print(jsonObject ?? "")
                completionHandler(statusCode, jsonObject)
            } else {
                print("life is not easy")
                completionHandler(statusCode, nil)
            }
        }
        
    }
}
