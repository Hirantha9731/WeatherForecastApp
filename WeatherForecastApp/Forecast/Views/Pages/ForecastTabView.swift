//
//  ForecastTabView.swift
//  Forecast
//
//  Created by Hirantha on 2023-04-25.
//

import SwiftUI

struct ForecastTabView: View {
    
    var body: some View {
        
        TabView {
            CityWeatherView()
                .tabItem {
                    Label("City", systemImage: "magnifyingglass")
                }
            CurrentWeatherView()
                .tabItem {
                    Label("WeatherNow", systemImage: "sun.max.fill")
                }
            HourlySummaryView()
                .tabItem {
                    Label("Hourly Summary", systemImage: "clock.fill")
                }
            ForecastView()
                .tabItem {
                    Label("Forecast", systemImage: "calendar")
                }
            PollutionView()
                .tabItem {
                    Label("Pollution", systemImage: "aqi.high")
                }
        }
        .tint(.blue)
    }
}

struct ForecaseTabView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastTabView()
            .environmentObject(WeatherDataModel())
            
    }
}
