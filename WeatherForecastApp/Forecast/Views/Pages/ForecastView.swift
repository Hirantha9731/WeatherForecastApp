//
//  ForecastView.swift
//  Forecast
//
//  Created by Hirantha on 2023-04-25.
//

import SwiftUI

struct ForecastView: View {
    
    @EnvironmentObject private var weatherDataModel: WeatherDataModel
    
    var body: some View {
        
        let forecastData = weatherDataModel.forecast30
        let forecastArray = forecastData?.daily ?? []
        
        ZStack{
            Image("background2")
                .resizable()
            VStack{
                
                Text("\(weatherDataModel.location)")
                    .font(.title)
                    .foregroundColor(.black)
                    .shadow(color: .black, radius: 0.5)
                    .multilineTextAlignment(.center)
                
                List(forecastArray){ forecastItem in
        
                    HStack{ //HStack 1
                        
                        // fetching image icon from the json response
                        AsyncImage(url: forecastItem.weather.first?.iconURL){
                            FetchedImage in
                            FetchedImage
                                .resizable()
                                .frame(width: 60, height: 60)
                        } placeholder: {
                            ProgressView()
                        }
                        Spacer()
                        
                        VStack{ // VStack 1
                            Text("\(forecastItem.weather.first?.weatherDescription.rawValue ?? "")")
                            
                            let dt_txt = forecastItem.dt
                            Text("\(getDate(dt_txt: dt_txt))")
                        }
                        
                        Spacer()
                        
                        Text("\(forecastItem.temp.max.getSingleDecimal())°C / \(forecastItem.temp.min.getSingleDecimal())°C")
                        
                    }
                    .padding(.vertical)
                }
                
            }
           
        }
        .opacity(0.8)
        
    }
    
    
    
    // return sunsrise time
    func getDate(dt_txt: Double) -> String{
        
        
        let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .none
                formatter.timeStyle = .medium
                formatter.locale = Locale(identifier: "en_US")
                formatter.dateFormat = "EEEE d"
                return formatter
            }()

        let setDate = dt_txt
        
        let setDateText = Date(timeIntervalSince1970: setDate)
        
        let formattedDate = dateFormatter.string(from: setDateText)
        
        return formattedDate
        
    }
    
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
            .environmentObject(WeatherDataModel())
    }
}
