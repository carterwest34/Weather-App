//
//  APIManager.swift
//  WeatherApp
//
//  Created by Izaak Prats on 11/14/18.
//  Copyright © 2018 Izaak Prats. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct APIManager {
    
    enum APIErrors: Error {
        case noData
        case noResponse
        case invalidData
    }
    
    
    
     func geocode(address: String, onCompletion: @escaping (GeocodingData?, Error?) -> Void ) {
        
        let googleURL = "https://maps.googleapis.com/maps/api/geocode/json?address="
        let url = googleURL + address + "&key=" + APIKeys.geocodingKey
        
        let request = Alamofire.request(url)
        
        request.responseJSON {response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                if let geocodingData  = GeocodingData(json: json) {
                    onCompletion(geocodingData, nil)
                } else {
                    onCompletion(nil, APIErrors.invalidData)
                }
                print(json)
            case .failure(let error):
                print(error.localizedDescription)
                onCompletion(nil, error)
            }
        }
    }
    
    // call darksky for weather at location (latitude, longitude)
     func getWeather(at location: Location, onComplete: @escaping (WeatherData?, Error?) -> Void) {
        let root = "https://api.darksky.net/forecast"
        let key = APIKeys.darkSkySecret
        
        let url = "\(root)/\(key)/\(location.latitude),\(location.longitude)/"
        
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("eurika")
                let json = JSON(value)
                if let weatherData = WeatherData(json: json) {
                    onComplete(weatherData, nil)
                } else {
                    onComplete(nil, APIErrors.invalidData)
                }
            case .failure(let error):
                onComplete(nil, error)
                print(error.localizedDescription)
            }
        }
    }
    
  
    
    
    
}

