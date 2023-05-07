//
//  WeatherDataModel.swift
//  Forecast
//
//  Created by Hirantha Waas on 2023-03-31.
//

import SwiftUI


class WeatherDataModel: ObservableObject {
    
    @AppStorage(AppStorageKeys.isFirstTimeUser) private var isFirstTimeUser: Bool = false
    
    @Published var forecast: MeteorologicalData?
    @Published var forecast30: ForecastData?
    @Published var cityName = ""
    @Published var location = ""

    init() {
        
        forecast = getWeatherFromJSON()
        
        // Updating Daily and Hourly data arrays
        forecast?.currentWeather.daily = forecast30?.daily ?? []
        forecast?.currentWeather.hourly = forecast30?.hourly ?? []

    }
    

    private func requestData<T: Decodable>(_ type: T.Type, for url: String) async throws -> T {
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
extension WeatherDataModel {
    
    func getWeatherFromJSON() -> MeteorologicalData {
        let currentData = loadFromJSONFile(CurrentWeather.self, "london-current-weather")
        let hourlySummary = loadFromJSONFile(ForecastWeather.self, "london-hourly-summary")
        let pollution = loadFromJSONFile(PollutionData.self, "london-pollution")
        let weather30 = loadFromJSONFile(ForecastData.self, "daily-weather")
        
        forecast30 = weather30
        
        return MeteorologicalData(currentWeather: currentData, forecastWeather: hourlySummary,
        pollution: pollution)
    }
    

}

// MARK: API functions
extension WeatherDataModel {
    
    func getCurrentWeatherForCity() async throws  -> CurrentWeather {
        
        let correctedCityName = cityName.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(WeatherAPI.current.url)&q=\(correctedCityName)"
        print(urlString)
        do {
            let currentWeather = try await requestData(CurrentWeather.self, for: urlString)
            return currentWeather
        } catch {
            throw error
        }
    }
    
    func getForecastWeatherForCity() async throws  -> ForecastWeather {
        
        let correctedCityName = cityName.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(WeatherAPI.forecast.url)&q=\(correctedCityName)"
        
        do {
            let forecastWeather = try await requestData(ForecastWeather.self, for: urlString)
            //print(forecastWeather)

            return forecastWeather

        } catch {
            throw error
        }
    }
    
    // getDailyWeatheForCity
    func getDailyWeatherForCity(lat: Double, lon: Double) async throws  -> Void{
        
        let weatherAPIUrlString = "\(WeatherAPI.forecast.dailyUrl)&lat=\(lat)&lon=\(lon)"
        
        do {
            let forecastWeather = try await requestData(ForecastData.self, for: weatherAPIUrlString)
            
            forecast?.currentWeather.daily = forecastWeather.daily
            forecast?.currentWeather.hourly = forecastWeather.hourly
            
            forecast30 = forecastWeather
            

        } catch {
            throw error
        }
    }
    
    
    
    // Getting pollution data from API, using coordinates
    func getPollutionData(lat:Double, lon:Double) async throws -> PollutionData{
        
        let urlString = "\(WeatherAPI.pollution.url)&lat=\(lat)&lon=\(lon)"
        print(urlString)
        
        do {
            let pollution = try await requestData(PollutionData.self, for: urlString)
            //print(pollution)
            return pollution

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
            let airPollutionData = try await getPollutionData(lat: lat, lon: lon)
            
            self.location = randomLocation
            
            // trying to execute in the main thread
            DispatchQueue.main.async {
                self.forecast = MeteorologicalData(currentWeather: currentWeatherForCity,
                                                   forecastWeather: forcastWhetherForCity,
                                                   pollution: airPollutionData)
            }
            
        } catch {
            throw error
        }
        
        
    }
}


// MARK: PollutionView Utils
extension WeatherDataModel{
    
    func getPollutionKeyValues() -> [PollutionDict]{
        if let forecastData = self.forecast,
           let comps = forecastData.pollution.list.first?.components{
            
            let dict = [
                PollutionDict(image:"so2",value: comps.so2),
                PollutionDict(image:"no",value: comps.no2),
                PollutionDict(image:"voc",value: comps.co),
                PollutionDict(image:"pm",value: comps.pm10),
            ]
            
            return dict
        }
        return []
    }
    
}

struct PollutionDict: Identifiable{
    let id = UUID()
    let image: String
    let value: Double
}


