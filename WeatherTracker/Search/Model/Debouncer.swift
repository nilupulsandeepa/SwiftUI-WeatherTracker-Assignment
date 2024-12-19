//
//  Debouncer.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-17.
//

import Foundation

public class Debouncer {
    private var task: Task<Void, Never>?
    private var delay: UInt8 = 1
    
    public func call(_ closure: @escaping () -> Void) {
        task?.cancel()
        task = Task {
            try? await Task.sleep(nanoseconds: UInt64(delay) * 1000000000) //Intentional Delay
            if !Task.isCancelled {
                closure()
            }
        }
    }
}
