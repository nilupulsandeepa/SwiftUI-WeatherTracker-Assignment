//
//  ContentView.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var contentVM: ContentViewVM = ContentViewVM()
    
    var body: some View {
        ZStack {
            if (contentVM.weatherUpdated) {
                HomeView()
                    .transition(.move(edge: .trailing))
            } else {
                LaunchView()
                    .transition(.asymmetric(insertion: .move(edge: .leading).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
            }
        }
        .padding([.horizontal], 24)
        .animation(.easeInOut, value: contentVM.weatherUpdated)
    }
}

#Preview {
    ContentView()
}
