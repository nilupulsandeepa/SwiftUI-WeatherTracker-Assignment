//
//  Extensions.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

import SwiftUI

extension Color {
    init (hex: String) {
        var hexTrimmed = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if (hexTrimmed.hasPrefix("#")) {
            hexTrimmed.removeFirst()
        }
        
        if (hexTrimmed.count == 6) {
            var rgbValue: UInt64 = 0
            Scanner(string: hexTrimmed).scanHexInt64(&rgbValue)
            
            let red = Double((rgbValue & 0xFF0000) >> 16) / 255
            let green = Double((rgbValue & 0x00FF00) >> 8) / 255
            let blue = Double(rgbValue & 0x0000FF) / 255
            
            self.init(red: red, green: green, blue: blue)
        } else if (hexTrimmed.count == 3) {
            var rgbValue: UInt64 = 0
            Scanner(string: hexTrimmed).scanHexInt64(&rgbValue)
            
            let preRed = Int64((rgbValue & 0xF00) >> 8)
            let red = Double((preRed << 4) | preRed) / 255
            let preGreen = Int64((rgbValue & 0x0F0) >> 4)
            let green = Double((preGreen << 4) | preGreen) / 255
            let preBlue = Int64((rgbValue & 0x00F))
            let blue = Double((preBlue << 4) | preBlue) / 255
            
            self.init(red: red, green: green, blue: blue)
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0)
        }
    }
}

extension String {
    func localizedString(key: String) -> String {
        Bundle.main.localizedString(forKey: key, value: nil, table: nil)
    }
}
