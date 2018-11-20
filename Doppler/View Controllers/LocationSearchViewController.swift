//
//  LocationSearchViewController.swift
//  Doppler
//
//  Created by Ryan Brashear on 11/15/18.
//  Copyright © 2018 Ryan Brashear. All rights reserved.
//

import UIKit

class LocationSearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    let apiManager = APIManager()
    var geocodingData: GeocodingData?
    var weatherData: WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
    }
    
    func handleError() {
        geocodingData = nil
        weatherData = nil
    }
    
    func retrieveGeocodingData(searchAdress: String) {
        apiManager.geocode(address: searchAdress) {
            (geocodingData, error) in
            if let recievedError = error {
                print(recievedError.localizedDescription)
                self.handleError()
                return
            }
            
            if let recievedData = geocodingData {
                self.geocodingData = recievedData
                print(recievedData.latitude)
                self.retrieveWeatherData(latitude: recievedData.latitude, longitude: recievedData.longitude)
            } else {
                self.handleError()
                return
            }
        }
    }
        
        func retrieveWeatherData(latitude: Double, longitude: Double) {
            apiManager.getWeather(at: (latitude, longitude)) {
            (weatherData, error) in
                if let recievedError = error {
                    print(recievedError.localizedDescription)
                    self.handleError()
                    return
                }
                if let recievedData = weatherData {
                    self.weatherData = recievedData
                    self.performSegue(withIdentifier: "unwindToWeatherDisplay", sender: Any?.self)
                } else {
                    self.handleError()
                    return
                }
            }
        }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchAdress = searchBar.text?.replacingOccurrences(of: " ", with: "+") else {
            return
        }
        retrieveGeocodingData(searchAdress: searchAdress)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? WeatherDisplayViewController, let retrievedGeocodingData = geocodingData, let retrievedWeatherData = weatherData {
            print(retrievedGeocodingData.latitude)
            print(retrievedGeocodingData.longitude)
            
            destinationVC.displayWeatherData = retrievedWeatherData
            destinationVC.displayGeocodingData = retrievedGeocodingData
        }
    }
}


    

