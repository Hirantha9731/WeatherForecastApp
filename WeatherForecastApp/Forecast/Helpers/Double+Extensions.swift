//
//  String+Extensions.swift
//  Forecast
//
//  Created by Hirantha on 4/1/23.
//

import Foundation

extension Double {
    func getDateFromUTC() -> Date {
        let date = Date(timeIntervalSince1970: self)
        return date
    }
    
    func getSingleDecimal() -> String {
        let string = String(format: "%.1f", self)
        return string
    }
}
