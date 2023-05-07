//
//  LocationHelper.swift
//  Forecast
//
//  Created by Hirantha on 4/1/23.
//

import Foundation

import CoreLocation

func getLocFromLatLong(lat: Double, lon: Double) async -> String
{
    var locationString: String
    var placemarks: [CLPlacemark]
    let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    
    let ceo: CLGeocoder = CLGeocoder()
    
    let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
    do {
        placemarks = try await ceo.reverseGeocodeLocation(loc)
        if placemarks.count > 0 {
            
            
            if let name = placemarks[0].name, !name.isEmpty {
                
                locationString = "\(name), \n \(placemarks[0].locality!), \(placemarks[0].country!)"
                
            } else {
                locationString = (placemarks[0].locality ?? "No City")
            }
            
            return locationString
        }
    } catch {
        //print("Reverse geodecoe fail: \(error.localizedDescription)")
        locationString = "No City, No Country"
       
        return locationString
    }
    
    return "Error getting Location"
}
