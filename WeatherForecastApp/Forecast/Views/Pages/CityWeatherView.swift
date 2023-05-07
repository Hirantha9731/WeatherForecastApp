//
//  CityWeatherView.swift
//  Forecast
//
//  Created by Hirantha on 2023-04-25.
//

import SwiftUI

struct CityWeatherView: View {
    
    @EnvironmentObject private var weatherDataModel: WeatherDataModel
    @State var isSearchOpen: Bool = false
    @State  var userLocation: String = ""
    
    @State private var isChangingLocation = false
    @State private var showAllertMessage = false
    @State private var errorMessage = ""
    
    var body: some View {
        
        let forecastData = weatherDataModel.forecast
        let currentWeatherData  = weatherDataModel.forecast?.currentWeather
        let currentDate = forecastData?.currentWeather.dt.getDateFromUTC() ?? Date()
        let displayIcon = forecastData?.currentWeather.weather.first?.iconURL
        
        ZStack {
            
            if let current = currentWeatherData{
                if current.weather.first?.main == .rain{
                    Image("background")
                        .resizable()
                }
                else{
                    Image("background2")
                        .resizable()
                }
            }
            else{
                Image("background2")
                    .resizable()
            }
            
           
            VStack {
                Spacer()
                
                HStack { // HStack 1
                    Spacer()
                    
                    Button {
                        self.isChangingLocation.toggle()
                    } label: {
                        Text("Change Location")
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $isSearchOpen) {
                    }
                    .padding()
                    
                    Spacer()
                }
                
                
                Text("\(weatherDataModel.location)")
                    .font(.title)
                    .foregroundColor(.black)
                    .shadow(color: .black, radius: 0.5)
                    .multilineTextAlignment(.center)
            
                
                Text("\(currentDate.formatted(date: .abbreviated, time: .shortened))")
                .padding()
                .font(.largeTitle)
                .foregroundColor(.black)
                .shadow(color: .black, radius: 1)
            
                Spacer()
                
                Group{
                    
                    Text("Temp: \(currentWeatherData?.main.temp.getSingleDecimal() ?? "")ºC")
                    
                    Text("Humidity:  \(currentWeatherData?.main.humidity ?? 0)%")
                    
                    Text("Pressure:  \(currentWeatherData?.main.pressure ?? 0) hPa")
                }
                .padding()
                .font(.title2)
                .foregroundColor(.black)
                .shadow(color: .black, radius: 0.5)
                
                
                HStack{ //Hstack2
                    
                    // fetching image icon from the json response
                    AsyncImage(url: displayIcon){
                        FetchedImage in
                        FetchedImage
                            .resizable()
                            .frame(width: 100, height: 100)
                    } placeholder: {
                        ProgressView()
                    }
                
                    Text("\(currentWeatherData?.weather.first?.description.rawValue ?? "")")
                        .font(.title2)

                }
                .padding()
                
                Spacer()
            }
            .onAppear {
                Task.init {
                    self.userLocation = ""
                }
            }
        }
        .opacity(0.8)
        .ignoresSafeArea()
        .sheet(isPresented: $isChangingLocation) {
            LocationSearch(
                showAlertMessage: $showAllertMessage,
                errorMessage: $errorMessage)
        }
        
        .alert(errorMessage, isPresented: $showAllertMessage){
            Button("ok"){
                
            }
        }
        
        .onAppear{
            Task.init{
                weatherDataModel.location = await getLocFromLatLong(lat: currentWeatherData?.coord.lat ?? 0.0, lon: currentWeatherData?.coord.lon ?? 0.0)
            }
        }
        
    
        
    }
}

struct CityWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CityWeatherView()
            .environmentObject(WeatherDataModel())
    }
}
