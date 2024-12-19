//
//  SearchItemViewVM.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-18.
//

import Foundation

@MainActor
public class SearchItemViewVM: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isImageLoading: Bool = false
    @Published var cityItem: City?
    @Published var weatherItem: Weather?
    
    private let searchService: SearchService
    
    public init(searchService: SearchService) {
        self.searchService = searchService
    }
    
    public func fetchWeatherForSearchItem() {
        Task {
            isLoading = true
            isImageLoading = true
            if let currentCity = cityItem {
                weatherItem = await searchService.fetchWeather(city: currentCity)
            }
            isLoading = false
        }
    }
    
    public func getTemperature() -> String {
        guard let weatherItem else { return "" }
        return "\((Int(weatherItem.current.tempC) / 10) == 0 ? "0" : "")\(Int(weatherItem.current.tempC))"
    }
}
