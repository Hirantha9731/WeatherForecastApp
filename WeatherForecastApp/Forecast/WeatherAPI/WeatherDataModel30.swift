//
//  WeatherDataModel30.swift
//  Forecast
//
//  Created by Hirantha on 5/6/23.
//

import SwiftUI


class WeatherDataModel2: ObservableObject {
    
    @AppStorage(AppStorageKeys.isFirstTimeUser) private var isFirstTimeUser: Bool = false
    
    @Published var forecast: MeteorologicalData30?
    @Published var city = ""
    @Published var location = ""

    init() {
        forecast = getWeatherFromJSON()
        
    }
    

    private func request<T: Decodable>(_ type: T.Type, for url: String) async throws -> T {
        guard let url = URL(string: url) else {
            throw fatalError("Invalid URL. Please check if the URL is correct")
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let weather =  try JSONDecoder().decode(type, from: data)
            return weather
        } catch {
            throw error
        }
    }
    
    // Loading file from JSON
    func loadFromJSONFile<T: Decodable>(_ type: T.Type, _ filename: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: "json")
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            let forecast = try decoder.decode(type, from: data)
            isFirstTimeUser = false
            return forecast
        } catch {
            fatalError("Couldn't parse \(filename) as \(type):\n\(error)")
        }
    }
}

// MARK: JSON functions
extension WeatherDataModel2 {
    
    func getWeatherFromJSON() -> MeteorologicalData30 {
        let daily = loadFromJSONFile(ForecastData.self, "daily-weather")
        return MeteorologicalData30(weather: daily)
    }
}

// MARK: API functions
extension WeatherDataModel2 {
    
    func getCurrentWeatherForCity() async throws  -> CurrentWeather {
        
        let correctedCityName = city.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(WeatherAPI.current.dailyUrl)&q=\(correctedCityName)"
        print(urlString)
        do {
            let currentWeather = try await request(CurrentWeather.self, for: urlString)
            return currentWeather
        } catch {
            throw error
        }
    }
    
    func getForecastWeatherForCity() async throws  -> ForecastWeather {
        
        let correctedCityName = city.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(WeatherAPI.forecast.url)&q=\(correctedCityName)"
        print(urlString)
        do {
            let forecastWeather = try await request(ForecastWeather.self, for: urlString)
            print(forecastWeather)

            return forecastWeather

        } catch {
            throw error
        }
    }
    
    
   
    
    
    func getMeteorologicalDataForCity() async throws{
        do {
            let currentWeatherForCity = try await getCurrentWeatherForCity()
            let forcastWhetherForCity = try await getForecastWeatherForCity()
            
            
            let lat = currentWeatherForCity.coord.lat
            let lon = currentWeatherForCity.coord.lon
            let randomLocation = try await getLocFromLatLong(lat: lat, lon: lon)
            
            self.location = randomLocation
            
            // trying to execute in the main thread
            
//            DispatchQueue.main.async {
//                self.forecast = MeteorologicalData30(currentWeather: currentWeatherForCity,
//                                                   forecastWeather: forcastWhetherForCity)
//            }
            
        } catch {
            throw error
        }
        
        
    }
}



