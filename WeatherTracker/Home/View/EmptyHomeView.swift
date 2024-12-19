//
//  EmptyHomeView.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

import SwiftUI

struct EmptyHomeView: View {
    var body: some View {
        VStack {
            Text("No City Selected".localizedString(key: "no_city_text"))
                .font(.custom("Poppins-SemiBold", size: 30))
            Text("Please search for a city".localizedString(key: "select_city_text"))
                .font(.custom("Poppins-SemiBold", size: 15))
        }
    }
}

#Preview {
    EmptyHomeView()
}
