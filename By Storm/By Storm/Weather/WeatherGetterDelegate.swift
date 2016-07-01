//
//  WeatherGetterDelegate.swift
//  By Storm
//
//  Created by Walker Kennedy on 7/1/16.
//  Copyright © 2016 Walker Kennedy. All rights reserved.
//

import Foundation

protocol WeatherGetterDelegate {
    func didGetWeather(weather: Weather)
    func didNotGetWeather(error: NSError)
}

class WeatherGetter {
    
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "eb071ce1f3f4c6869d11bf4d5bbd87c6"
    
    private var delegate: WeatherGetterDelegate
    
    init(delegate: WeatherGetterDelegate) {
        self.delegate = delegate
    }
    
    func getWeatherByPostalCode(postalCode: String) {
        let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?q=\(postalCode)&appid=\(openWeatherMapAPIKey)")!
        getWeather(weatherRequestURL)
    }
    
    private func getWeather(weatherRequestURL: NSURL) {
        
        // This is a pretty simple networking task, so the shared session will do.
        let session = NSURLSession.sharedSession()
        
        // The data task retrieves the data.
        let dataTask = session.dataTaskWithURL(weatherRequestURL) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if let networkError = error {
                // Case 1: Error
                // An error occurred while trying to get data from the server.
                self.delegate.didNotGetWeather(networkError)
            }
            else {
                // Successful response from server
                do {
                    // try convert to dict
                    let weatherData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! [String: AnyObject]
                    
                    // If we made it to this point, we've successfully converted the
                    // JSON-formatted weather data into a Swift dictionary.
                    // Let's now used that dictionary to initialize a Weather struct.
                    let weather = Weather(weatherData: weatherData)
                    
                    // Now that we have the Weather struct, let's notify the view controller,
                    // which will use it to display the weather to the user.
                    self.delegate.didGetWeather(weather)
                } catch let jsonError as NSError {
                    // An error occurred while trying to convert the data into a dictionary.
                    self.delegate.didNotGetWeather(jsonError)
                }
            }
        }
        
        dataTask.resume()
    }
}


