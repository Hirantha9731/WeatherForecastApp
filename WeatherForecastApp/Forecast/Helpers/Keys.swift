//
//  Keys.swift
//  Forecast
//
//  Created by Hirantha on 2023-03-31.
//

import Foundation

enum WeatherAPI: String {
    
    case current = "weather"
    case forecast = "forecast"
    case pollution = "air_pollution"
    
    
    var url: String {
        let key = "fee43f92aa2707b8989e7e857f754b46"
        return "https://api.openweathermap.org/data/2.5/\(self.rawValue)?appid=\(key)&units=metric"
    }
    
    var dailyUrl: String {
            let key = "8cf73a2e879fc2594057c4be0fb19053"
            return "https://api.openweathermap.org/data/3.0/onecall?appid=\(key)&units=metric"
    }
    
}

enum AppStorageKeys {
    static let isFirstTimeUser: String = "appstorage.key.is-first-time-user"
}

enum MiscConstants {
    static let forecastJSONName = "london"
}
