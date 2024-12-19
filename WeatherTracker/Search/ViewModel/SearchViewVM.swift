//
//  SearchViewVM.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-17.
//

import Foundation
import Network

@MainActor
public class SearchViewVM: ObservableObject {
    @Published var isSearching: Bool = true
    @Published var searchText: String = ""
    @Published var searchResults: [City] = []
    @Published var shouldShowNetworkAlert: Bool = false
    
    private var searchService: SearchService = SearchService()
    
    init() {
        registerForNotifications()
    }
    
    public func didSelectCity(_ city: City) {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: Namespace.NotificationKeys.cityUpdated),
            object: nil,
            userInfo: ["selectedCity": city]
        )
    }
    
    public func search() {
        if (NetworkHandler.shared.getCurrentNetworkStatus() == .satisfied) {
            guard !searchText.isEmpty else { return }
            
            isSearching = true
            Task {
                searchResults = await searchService.fetchSearchResults(searchQuery: searchText)
                try? await Task.sleep(nanoseconds: 1000000000) //Intentional Delay
                isSearching = false
            }
        } else {
            shouldShowNetworkAlert = true
        }
    }
    
    public func checkNetworkStatus() {
        if (NetworkHandler.shared.getCurrentNetworkStatus() != .satisfied) {
            shouldShowNetworkAlert = true
        }
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(searchTermChanged(_:)),
            name: NSNotification.Name(rawValue: Namespace.NotificationKeys.searchTermChanged),
            object: nil
        )
    }
    
    @objc private func searchTermChanged(_ notification: Notification) {
        let userInfo = notification.userInfo
        guard let newValue = userInfo?["searchTerm"] as? String else { return }
        searchResults.removeAll()
        searchText = newValue
        search()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SearchViewVM: @preconcurrency NetworkMonitorable {
    public func networkStatusChanged(status: NWPath.Status) {
        DispatchQueue.main.async {
            [weak self] in
            guard let self else { return }
            self.shouldShowNetworkAlert = status != .satisfied
            if (status == .satisfied) {
                self.search()
            }
        }
    }
}
