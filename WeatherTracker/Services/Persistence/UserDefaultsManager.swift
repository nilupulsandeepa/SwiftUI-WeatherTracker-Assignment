//
//  UserDefaultsManager.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

import Foundation

public class UserDefaultsManager {
    public static var shared = UserDefaultsManager()
    
    public var userDefaults: UserDefaults!
    
    public var currentCity: City? {
        set {
            let newCityData = try? JSONEncoder().encode(newValue)
            userDefaults.setValue(newCityData, forKey: Namespace.UserDefaultsKeys.currentCity)
        }
        get {
            if let cityData = userDefaults.data(forKey: Namespace.UserDefaultsKeys.currentCity) {
                return try? JSONDecoder().decode(City.self, from: cityData)
            }
            return nil
        }
    }
    
    private init() {
        userDefaults = UserDefaults.standard
    }
}
