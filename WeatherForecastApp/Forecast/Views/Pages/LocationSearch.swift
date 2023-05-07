//
//  LocationSearch.swift
//  Forecast
//
//  Created by Hirantha on 2023-04-25.
//

import SwiftUI
import CoreLocation

struct LocationSearch: View {
    
    
    @State var cityTextInput: String =  ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var weatherDataModel: WeatherDataModel
    
    @Binding public var showAlertMessage: Bool
    @Binding public var errorMessage: String
    
    var body: some View {
        
        ZStack {
            Color.cyan.edgesIgnoringSafeArea(.all)
            VStack {
                TextField("City", text: $cityTextInput)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                // Search button
                Button {
                    CLGeocoder().geocodeAddressString(cityTextInput) {
                        (locationmarks, error) in
                        guard error == nil else {
                            errorMessage = error?.localizedDescription ?? ""
                            showAlertMessage.toggle()
                            return
                        }
                        if let lat = locationmarks?.first?.location?.coordinate.latitude,
                           let lon = locationmarks?.first?.location?.coordinate.longitude {
                            Task {
                                do {
                                    let _ = try await weatherDataModel.getDailyWeatherForCity(lat: lat, lon: lon)
                                    
                                    weatherDataModel.cityName = cityTextInput
                                    try await weatherDataModel.getMeteorologicalDataForCity()
                                    
                                   
                                } catch {
                                    print("Search_error: \(error.localizedDescription)")
                                            errorMessage = error.localizedDescription
                                            showAlertMessage.toggle()
                                   
                                }
                            }
                           
                        }
                        
                    }
                        
                    dismiss()
                    
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tint(.black)
                .buttonStyle(.bordered)
                    
            }
            
            .padding()
        }
        
    }
    
}

