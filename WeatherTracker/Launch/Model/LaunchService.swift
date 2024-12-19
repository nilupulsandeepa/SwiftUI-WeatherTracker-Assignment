//
//  LaunchService.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

import Foundation

public class LaunchService {
    public func getSavedCity() -> City? {
        return UserDefaultsManager.shared.currentCity
    }
    
    public func fetchWeather(city: City) async -> Weather? {
        let url = "https://api.weatherapi.com/v1/current.json"
        let queryParams: [String: String] = [
            "key": Environment.apiKey,
            "q": city.getLatLonString()
        ]
        let data = await NetworkHandler.get(url: url, queryParams: queryParams)
        if
            let weatherData = data,
            let weatherResponse = try? JSONDecoder().decode(Weather.self, from: weatherData) {
            return weatherResponse
        }
        return nil
    }
}
