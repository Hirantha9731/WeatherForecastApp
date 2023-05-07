//
//  Pollution.swift
//  Forecast
//
//  Created by Hirantha on 2023-04-25.
//

import Foundation

struct PollutionData: Codable{
    let list: [Pollution]
    
}

struct Pollution: Codable{
    let components: PollutionComponents
}


struct PollutionComponents: Codable{
    
    let so2: Double
    let no2: Double
    let co: Double
    let pm10: Double
}
