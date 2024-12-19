//
//  WeatherResponse.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

import Foundation

public struct Weather: Codable {
    public var location: WeatherLocation
    public var current: WeatherCurrent
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
        case current = "current"
    }
}

public struct WeatherLocation: Codable {
    public var city: String
    public var lat: Double
    public var lon: Double
    
    enum CodingKeys: String, CodingKey {
        case city = "name"
        case lat = "lat"
        case lon = "lon"
    }
}

public struct WeatherCurrent: Codable {
    public var tempC: Double
    public var condition: WeatherCondition
    public var humidity: Double
    public var feelsLikeC: Double
    public var uv: Double
    
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition = "condition"
        case humidity = "humidity"
        case feelsLikeC = "feelslike_c"
        case uv = "uv"
    }
}

public struct WeatherCondition: Codable {
    public var condition: String
    public var icon: String
    
    enum CodingKeys: String, CodingKey {
        case condition = "text"
        case icon = "icon"
    }
}
