//
//  HomeViewVM.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-17.
//

import Foundation

@MainActor
public class HomeViewVM: ObservableObject {
    @Published var isWeatherAvailable: Bool = false
    @Published var shouldShowSearchView: Bool = false
    @Published var isWeatherLoading: Bool = true
    @Published var shouldShowServerErrorAlert: Bool = false
    @Published var shouldShowErrorView: Bool = false
    @Published var searchTerm: String = ""
    @Published var currentCity: City?
    @Published var currentWeather: Weather?
    
    private var weatherService: WeatherService = WeatherService()
    
    init() {
        registerForNotifications()
        isWeatherAvailable = UserDefaultsManager.shared.currentCity != nil
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didUpdateCity(_:)),
            name: NSNotification.Name(rawValue: Namespace.NotificationKeys.cityUpdated),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didFetchedWeatherAtLoad(_:)),
            name: NSNotification.Name(rawValue: Namespace.NotificationKeys.currentWeatherLoaded),
            object: nil
        )
    }
    
    @objc private func didUpdateCity(_ notification: Notification) {
        guard let city = notification.userInfo?["selectedCity"] as? City else { return }
        shouldShowSearchView = false
        isWeatherAvailable = true
        currentCity = city
        isWeatherAvailable = true
        UserDefaultsManager.shared.currentCity = city
        fetchCurrentWeather()
        searchTerm = ""
    }
    
    @objc private func didFetchedWeatherAtLoad(_ notification: Notification) {
        guard let currentWeatherData = notification.userInfo?["currentWeather"] as? Weather else { return }
        shouldShowSearchView = false
        isWeatherAvailable = true
        currentCity = UserDefaultsManager.shared.currentCity
        isWeatherAvailable = true
        currentWeather = currentWeatherData
        isWeatherLoading = false
    }
    
    public func searchTermChanged() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Namespace.NotificationKeys.searchTermChanged), object: nil, userInfo: ["searchTerm": searchTerm])
    }
    
    private func fetchCurrentWeather() {
        isWeatherLoading = true
        guard let currentCity else { return }
        Task {
            if let weatherResponse = await weatherService.fetchWeather(city: currentCity) {
                currentWeather = weatherResponse
                isWeatherLoading = false
            } else {
                shouldShowServerErrorAlert = true
                shouldShowErrorView = true
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
