//
//  HourlySummaryView.swift
//  Forecast
//
//  Created by Hirantha on 2023-04-25.
//

import SwiftUI

struct HourlySummaryView: View {
    
    @EnvironmentObject private var weatherDataModel: WeatherDataModel

    var body: some View {
        
        let forecastData = weatherDataModel.forecast30
        let forecastArray = forecastData?.hourly ?? []
        
        ZStack{
            Image("background2")
                .resizable()
            VStack{
                
                Text("\(weatherDataModel.location)")
                    .font(.title)
                    .foregroundColor(.black)
                    .shadow(color: .black, radius: 0.5)
                    .multilineTextAlignment(.center)
                
                List(forecastArray){ forecast in
        
                    HStack{
                    
                        VStack{
                            Text("\(getTime(dt_time: forecast.dt))")
                            Text("\(getDate(dt_day: forecast.dt))")
                        }
                        
                        Spacer()
                        
                        // fetching image icon from the json response
                        AsyncImage(url: forecast.weather.first?.iconURL){
                            FetchedImage in
                            FetchedImage
                                .resizable()
                                .frame(width: 60, height: 60)
                        } placeholder: {
                            ProgressView()
                        }
                        Spacer()
                        
                        Text("\(forecast.temp.getSingleDecimal())°C")
                        Text("\(forecast.weather.first?.main.rawValue ?? "")")
                    }
                    .padding(.vertical)
                }
                
            }
           
        }
        .opacity(0.8)
                
    }
    
    
    // Display Date
    func getDate(dt_day: Double) -> String{
        
        let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .none
                formatter.timeStyle = .medium
                formatter.dateFormat = "EEE"
                return formatter
            }()

        let setDate = dt_day
        
        let currentDate = Date(timeIntervalSince1970: setDate)
        
        let formattedDate = dateFormatter.string(from: currentDate)

        return formattedDate
    
    }
    
    
    // Display Time
    func getTime(dt_time: Double) -> String{
        
        let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .none
                formatter.timeStyle = .medium
                formatter.dateFormat = "HH a"
                return formatter
            }()

        let setTime = dt_time
        
        let currentTime = Date(timeIntervalSince1970: setTime)
        
        let formattedTime = dateFormatter.string(from: currentTime)

        return formattedTime
    
    }
}

struct HourlySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        HourlySummaryView()
            .environmentObject(WeatherDataModel())
    }
    
}
