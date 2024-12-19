//
//  WeatherTrackerApp.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

import SwiftUI

@main
struct WeatherTrackerApp: App {
    
    init () {
        NetworkHandler.shared.startNetworkMonitoring()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
