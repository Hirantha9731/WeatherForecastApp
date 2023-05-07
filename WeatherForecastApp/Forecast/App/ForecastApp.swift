//
//  ForecastApp.swift
//  Forecast
//
//  Created by Hirantha on 2023-04-22.
//

import SwiftUI

@main
struct ForecastApp: App {
    
    @StateObject private var weatherDataModel = WeatherDataModel()
    
    var body: some Scene {
        WindowGroup {
            ForecastTabView()
                .environmentObject(weatherDataModel)
        }
    }
}


