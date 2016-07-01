//
//  WeatherController.swift
//  By Storm
//
//  Created by Walker Kennedy on 6/29/16.
//  Copyright © 2016 Walker Kennedy. All rights reserved.
//

import Foundation
class WeatherGetter {
    
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "eb071ce1f3f4c6869d11bf4d5bbd87c6"
    
    func getWeather(city: String) {
        
        // This is a pretty simple networking task, so the shared session will do.
        let session = NSURLSession.sharedSession()
        
        if let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?q=\(city)&appid=\(openWeatherMapAPIKey)") {
            // The data task retrieves the data.
            let dataTask = session.dataTaskWithURL(weatherRequestURL) {
                (data: NSData?, response: NSURLResponse?, error: NSError?) in
                if let error = error {
                    // Case 1: Error
                    // We got some kind of error while trying to get data from the server.
                    print("Error:\n\(error)")
                }
                else {
                    // Case 2: Success
                    // We got a response from the server!
                    print("Raw data:\n\(data!)\n")
                    let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
                    print("Human-readable data:\n\(dataString!)")
                }
            }
            
            // The data task is set up...launch it!
            dataTask.resume()
        }
        
        
    }
    // BY STORM
}

