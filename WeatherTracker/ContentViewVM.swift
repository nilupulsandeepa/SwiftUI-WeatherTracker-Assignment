//
//  ContentViewVM.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

import Foundation

@MainActor
public class ContentViewVM: ObservableObject {
    
    @Published var weatherUpdated: Bool = false
    @Published var emptyWeather: Bool = false
    
    init() {
        registerForNotifications()
    }
    
    public func registerForNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didUpdateWeatherState),
            name: Notification.Name(rawValue: Namespace.NotificationKeys.launchLoadingComplete),
            object: nil
        )
    }
    
    @objc private func didUpdateWeatherState() {
        emptyWeather = false
        weatherUpdated = true
    }
}
