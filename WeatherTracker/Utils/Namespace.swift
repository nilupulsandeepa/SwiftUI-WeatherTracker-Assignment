//
//  Namespace.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

import Foundation

public struct Namespace {
    public struct UserDefaultsKeys {
        public static let currentCity = "com.myexample.weathertracker.userdefaults.currentCity"
    }
    
    public struct NotificationKeys {
        public static let cityUpdated = "com.myexample.weathertracker.notification.cityUpdated"
        public static let cityNotSaved = "com.myexample.weathertracker.notification.cityNotSaved"
        public static let searchTermChanged = "com.myexample.weathertracker.notification.searchTermChanged"
        public static let citySelected = "com.myexample.weathertracker.notification.citySelected"
        public static let currentWeatherLoaded = "com.myexample.weathertracker.notification.currentWeatherLoaded"
        public static let launchLoadingComplete = "com.myexample.weathertracker.notification.launchLoadingComplete"
    }
}
