//
//  PollutionView.swift
//  Forecast
//
//  Created by Hirantha on 2023-04-25.
//

import SwiftUI

struct PollutionView: View {
    
    @EnvironmentObject private var weatherDataModel: WeatherDataModel
    
    var body: some View {
        
        let pollutionData = weatherDataModel.getPollutionKeyValues()
        let forecastData = weatherDataModel.forecast
        let currentWeatherData  = weatherDataModel.forecast?.currentWeather
        let displayIcon = forecastData?.currentWeather.weather.first?.iconURL
        
        ZStack{
            
            if let current = currentWeatherData{
                if current.weather.first?.main == .rain{
                    Image("background")
                        .resizable()
                        .ignoresSafeArea()
                        .opacity(0.8)
                }
                else{
                    Image("background2")
                        .resizable()
                        .ignoresSafeArea()
                        .opacity(0.8)
                }
            }
            else{
                Image("background2")
                    .resizable()
                    .ignoresSafeArea()
                    .opacity(0.8)
            }

            VStack{
                
                Text("\(weatherDataModel.location)")
                    .font(.title)
                    .foregroundColor(.black)
                    .shadow(color: .black, radius: 0.5)
                    .multilineTextAlignment(.center)
                
                Text("\(currentWeatherData?.main.temp.getSingleDecimal() ?? "")ºC")
                    .padding()
                    .font(.title)
                    .foregroundColor(.black)
                    .shadow(color: .black, radius: 0.5)
                
                
                HStack{ //Hstack1
                    
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
                        .font(.system(size: 20))
                        .fontWeight(.bold)

                }
                .padding(.top,20)
                
                
                HStack{ //Hstack2
                    
                    Group{
                        Text("H: \(currentWeatherData?.main.temp_max.getSingleDecimal() ?? "")ºC")
                          
                        Text("Low: \(currentWeatherData?.main.temp_min.getSingleDecimal() ?? "")ºC")
                    }
                    .font(.system(size: 20))
                    .padding()
                    .fontWeight(.bold)

                }
                .padding(.top,10)
                
                
                Text("Feels Like: \(currentWeatherData?.main.feels_like.getSingleDecimal() ?? "")ºC")
                    .font(.system(size: 20))
                    .padding()
                    .fontWeight(.bold)
                
                Text("Air Qaulity Data:")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .shadow(color: .black, radius: 0.5)
                    .multilineTextAlignment(.center)
                
                
                // pollution data values
                HStack{
                    ForEach(pollutionData){
                        data in
                        VStack{
                            Image(data.image)
                            Text("\(data.value.getSingleDecimal())")
                                .fontWeight(.bold)
                        }
                    }
                    
                }
                
            }
        }
        
    }
}

struct PollutionView_Previews: PreviewProvider {
    static var previews: some View {
        PollutionView()
            .environmentObject(WeatherDataModel())
    }
}
