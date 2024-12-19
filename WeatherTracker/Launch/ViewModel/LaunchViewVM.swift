//
//  LaunchViewVM.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

import Foundation
import Network

@MainActor
public class LaunchViewVM: ObservableObject {
    @Published var hasSavedLocation: Bool = false
    @Published var shouldShowServerErrorAlert: Bool = false
    @Published var shouldShowNetworkAlert: Bool = false
    @Published var isNetworkError: Bool = false
    
    private var currentWeather: Weather?
    
    var launchService: LaunchService = LaunchService()
    
    public func checkSavedLocation() {
        if (NetworkHandler.shared.getCurrentNetworkStatus() == .satisfied) {
            DispatchQueue.main.async {
                [weak self] in
                guard let self else { return }
                self.isNetworkError = false
            }
            if let savedLocation = launchService.getSavedCity() {
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self else { return }
                    self.hasSavedLocation = true
                }
                Task {
                    currentWeather = await launchService.fetchWeather(city: savedLocation)
                    try? await Task.sleep(nanoseconds: 1500000000) //Intentional Delay
                    if currentWeather != nil {
                        notifyLaunchCompleted()
                        try? await Task.sleep(nanoseconds: UInt64(0.5 * 1000000000)) //Intentional Delay
                        notifyWeatherLoaded()
                    } else {
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let self else { return }
                            self.shouldShowServerErrorAlert = true
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self else { return }
                    self.hasSavedLocation = false
                }
                Task {
                    try? await Task.sleep(nanoseconds: 1500000000) //Intentional Delay
                    notifyLaunchCompleted()
                }
            }
        } else {
            isNetworkError = true
        }
    }
    
    private func notifyWeatherLoaded() {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: Namespace.NotificationKeys.currentWeatherLoaded),
            object: nil,
            userInfo: ["currentWeather": currentWeather as Any]
        )
    }
    
    private func notifyLaunchCompleted() {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: Namespace.NotificationKeys.launchLoadingComplete),
            object: nil
        )
    }
    
    private func updateNetworkStatus(isSatisfied: Bool) {
        DispatchQueue.main.async {
            [weak self] in
            guard let self else { return }
            self.shouldShowNetworkAlert = isSatisfied
            self.isNetworkError = isSatisfied
        }
    }
}

extension LaunchViewVM: @preconcurrency NetworkMonitorable {
    public func networkStatusChanged(status: NWPath.Status) {
        updateNetworkStatus(isSatisfied: status != .satisfied)
        if (status == .satisfied) {
            checkSavedLocation()
        }
    }
}
