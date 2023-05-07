//
//  CurrentWeatherView.swift
//  Forecast
//
//  Created by Hirantha on 2023-04-25.
//

import SwiftUI

struct CurrentWeatherView: View {
    
    @EnvironmentObject private var weatherDataModel: WeatherDataModel
    @State private var sunriseTimeText = ""
    @State private var sunsetTimeText = ""
    
    var body: some View {
        
        let forecastData = weatherDataModel.forecast
        let currentWeatherData  = weatherDataModel.forecast?.currentWeather
        let displayIcon = forecastData?.currentWeather.weather.first?.iconURL

        ZStack{
            
            Image("background2")
                .resizable()
                .ignoresSafeArea()
            
            
            VStack{
                
                Text("\(weatherDataModel.location)")
                    .font(.title)
                    .foregroundColor(.black)
                    .shadow(color: .black, radius: 0.5)
                    .multilineTextAlignment(.center)
                
                Text("\(currentWeatherData?.main.temp.getSingleDecimal() ?? "")ºC")
                    .padding()
                    .font(.title2)
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
                        .font(.title3)

                }
                .padding(.top,20)
                
                
                HStack{ //Hstack2
                    
                    Group{
                        Text("H: \(currentWeatherData?.main.temp_max.getSingleDecimal() ?? "")ºC \t")
                          
                        Text("Low: \(currentWeatherData?.main.temp_min.getSingleDecimal() ?? "")ºC")
                    }
                }
                .font(.system(size: 20))
                .padding(.top,20)
                
                
                Text("Feels Like: \(currentWeatherData?.main.feels_like.getSingleDecimal() ?? "")ºC")
                    .font(.system(size: 20))
                    .padding(.top,20)
        
                
                HStack{//Hstack3
                    
                    Text("Wind Speed: \(currentWeatherData?.wind.speed ?? 0, specifier: "%.2f") m/s \t")
                        .padding(.leading)
                    
                    // Getting wind direction
                    let wind = Wind(speed: currentWeatherData?.wind.speed ?? 0, deg: currentWeatherData?.wind.deg ?? 0.0)
                    let windDirection = wind.direction
                    
                    Text("Direction: \(windDirection)")
                        .padding(.trailing)

                }
                .font(.system(size: 20))
                .padding(.top,30)
                
                HStack{ //Hstack4
                    
                    Text("Humidty: \(currentWeatherData?.main.humidity ?? 0)% \t\t")
                    
                    Text("Pressure: \(currentWeatherData?.main.pressure ?? 0) hPg")
                }
                .font(.system(size: 20))
                .padding(.top,30)
                
                
                HStack{
                    
                    Group{
                        Image(systemName: "sunrise.fill")
                            .foregroundColor(Color.yellow)
                            .font(.system(size: 30))
                    
                        Text(getSunriseTime() + "\t\t")
                    }
                    
                    Group{
                        Image(systemName: "sunset.fill")
                            .foregroundColor(Color.yellow)
                            .font(.system(size: 30))
                        
                        Text(getSunsetTime())
                    }
                }
                .font(.system(size: 20))
                .padding(.top,30)
                
            }
        
        }
       
    }
    
    // return sunsrise time
    func getSunriseTime() -> String{
        
        let current  = weatherDataModel.forecast?.currentWeather
        
        let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .none
                formatter.timeStyle = .medium
                formatter.dateFormat = "HH:mm a"
                return formatter
            }()

        let sunriseTime = current?.sys.sunrise ?? 0.0
        
        let sunriseDate = Date(timeIntervalSince1970: sunriseTime)
        
        let formattedSunriseTime = dateFormatter.string(from: sunriseDate)
        DispatchQueue.main.async {
            self.sunriseTimeText = formattedSunriseTime
        }
        
        return formattedSunriseTime
    
    }
    
    // return sunset time
    func getSunsetTime() -> String{
        
        let current  = weatherDataModel.forecast?.currentWeather
        
        let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .none
                formatter.timeStyle = .medium
                formatter.dateFormat = "HH:mm a"
                return formatter
            }()

        let sunsetTime = current?.sys.sunset ?? 0.0
        
        let sunsetDate = Date(timeIntervalSince1970: sunsetTime)
        
        let formattedSunsetTime = dateFormatter.string(from: sunsetDate)
        DispatchQueue.main.async {
            self.sunsetTimeText = formattedSunsetTime
        }
        
        return self.sunsetTimeText
    
    }

    
}



struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView()
            .environmentObject(WeatherDataModel())
    }
}
