//
//  CacheCity.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

public struct City: Codable, Hashable {
    let city: String
    let lat: Double
    let lon: Double
    
    public init(city: String, lat: Double, lon: Double) {
        self.city = city
        self.lat = lat
        self.lon = lon
    }
    
    public func getCity() -> String {
        return city
    }
    
    public func getLatLonString() -> String {
        return "\(lat),\(lon)"
    }
    
    enum CodingKeys: String, CodingKey {
        case city = "name"
        case lat = "lat"
        case lon = "lon"
    }
}
