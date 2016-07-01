//
//  ViewController.swift
//  By Storm
//
//  Created by Walker Kennedy on 7/1/16.
//  Copyright © 2016 Walker Kennedy. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, WeatherGetterDelegate {
    let locationManager = CLLocationManager()
    var weather: WeatherGetter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weather = WeatherGetter(delegate: self)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks?.count > 0 {
                let pm = placemarks![0]
                if let currentArea = pm.postalCode as String! {
                    self.weather.getWeatherByPostalCode(currentArea)
                }
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    
    // MARK: -
    
    // MARK: WeatherGetterDelegate methods
    // -----------------------------------
    
    func didGetWeather(weather: Weather) {
        print(weather)
        locationManager.stopUpdatingLocation()
    }
    
    func didNotGetWeather(error: NSError) {
        print("didNotGetWeather error: \(error)")
        locationManager.stopUpdatingLocation()
    }
}

