//
//  ContentModel.swift
//  City Sights App
//
//  Created by Michael Baumgarten on 10/11/21.
//

import Foundation
import CoreLocation

class ContentModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var locationManager = CLLocationManager()
    
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    
    @Published var restaurants = [Business]()
    @Published var sights = [Business]()
    
    override init() {
        // init method of NSObject
        super.init()

        // set content model as the delgate of the location manager
        locationManager.delegate = self
        
        // Request authorization/permission from user
        locationManager.requestWhenInUseAuthorization()

        // start geolocating user, after we get permission
    }
    
    // MARK - Location Manager Delegate Methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        // Update the authorizationState property
        self.authorizationState = locationManager.authorizationStatus

        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            // we have permission
            locationManager.startUpdatingLocation()
        } else if locationManager.authorizationStatus == .denied {
            // we dont have permission
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.first ?? "no location" )
        
        let userLocation = locations.first
        
        if userLocation != nil {
            // stop requesing the location
            locationManager.stopUpdatingLocation()
            
            // TODO: If we have the coordinates, send into Yelp API
            getBusinesses(category: Constants.sightsKey, location: userLocation!)
            getBusinesses(category: Constants.restaurantsKey, location: userLocation!)
        }
    }
    
    // MARK: Yelp API methods
    func getBusinesses(category:String, location:CLLocation) {
        // Create URL
        var urlComp = URLComponents(string: Constants.apiURL)
        urlComp?.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "categories", value: category),
            URLQueryItem(name: "limit", value: "6")
        ]
        let url = urlComp?.url
        
        if let url = url {
            // Create URL request
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")

            // Get URLSession
            let session = URLSession.shared
            
            // Create Data task
            let dataTask = session.dataTask(with: request) { data, response, error in
                // check that there isn't an error
                if error == nil {
                    
                    do {
                        // Parse json
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(BusinessSearch.self, from: data!)
                        
                        // Sort businesses
                        var businesses = result.businesses
                        businesses.sort { (b1, b2) -> Bool in
                            return b1.distance ?? 0 < b2.distance ?? 0
                        }
                        
                        // call getimage for each business
                        for b in businesses {
                            b.getImageData()
                        }
                        
                        DispatchQueue.main.async {
                            switch category {
                            case Constants.sightsKey:
                                self.sights = businesses
                            case Constants.restaurantsKey:
                                self.restaurants =  businesses
                            default:
                                break
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            
            // Start the Data task
            dataTask.resume()
        }
    }
}
