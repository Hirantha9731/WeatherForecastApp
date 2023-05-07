//
//  WeatherCodables.swift
//  Forecast
//
//  Created by Hirantha on 2023-04-25.
//

import Foundation

// MARK: - Forecast

struct MeteorologicalData: Identifiable {
    let id = UUID()
    var currentWeather: CurrentWeather
    let forecastWeather: ForecastWeather
    let pollution: PollutionData
}

// Forecast decodables
struct ForecastWeather: Codable {
    let list: [Forecast]
    let city: City
}

struct Forecast: Codable, Identifiable {
    let id = UUID()
    let dt: Double
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let dt_txt: String
}

struct City: Codable {
    let name: String
    let country: String
}
