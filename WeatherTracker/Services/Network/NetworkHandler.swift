//
//  NetworkRequestManager.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

import Foundation
import Network

public class NetworkHandler {
    public static var shared: NetworkHandler = NetworkHandler()
    
    private static var networkMonitor: NWPathMonitor?
    public static var networkMonitorDelegate: NetworkMonitorable?
    private var isNetworkUpdateCalled: Bool = false
    private var networkStatus: NWPath.Status = .unsatisfied
    
    public func startNetworkMonitoring() {
        NetworkHandler.networkMonitor = NWPathMonitor()
        NetworkHandler.networkMonitor!.pathUpdateHandler = {
            [weak self] path in
            if let nhSelf = self {
                nhSelf.networkStatus = path.status
                if (!nhSelf.isNetworkUpdateCalled) {
                    Task {
                        [weak self] in
                        guard let self else { return }
                        try? await Task.sleep(nanoseconds: 1500000000)
                        if (self.networkStatus == .satisfied) {
                            NetworkHandler.networkMonitorDelegate?.networkStatusChanged(status: .satisfied)
                        } else if (self.networkStatus == .unsatisfied) {
                            NetworkHandler.networkMonitorDelegate?.networkStatusChanged(status: .unsatisfied)
                        }
                    }
                }
            }
        }
        
        let networkQueue = DispatchQueue(label: "com.myexample.weathertracker.networkQueue")
        NetworkHandler.networkMonitor?.start(queue: networkQueue)
    }
    
    public func getCurrentNetworkStatus() -> NWPath.Status {
        return networkStatus
    }
    
    public static func get(url: String, queryParams: [String: String]?) async -> Data? {
        var urlComponents = URLComponents(string: url)!
        urlComponents.queryItems = queryParams?.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "GET"
        let responseData: (data: Data, response: URLResponse)? = try? await URLSession.shared.data(for: urlRequest)
        if let response = responseData?.response as? HTTPURLResponse {
            if (response.statusCode >= 200 && response.statusCode < 300) {
                return responseData?.data
            }
        }
        return nil
    }
    
    deinit {
        NetworkHandler.networkMonitor?.cancel()
        NetworkHandler.networkMonitor = nil
        NetworkHandler.networkMonitorDelegate = nil
    }
}

public protocol NetworkMonitorable: AnyObject {
    func networkStatusChanged(status: NWPath.Status)
}
