//
//  LaunchView.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

import SwiftUI

struct LaunchView: View {
    //---- VM States
    @StateObject private var launchVM: LaunchViewVM = LaunchViewVM()
    
    //---- Animation states
    @State var rotationAngle: Double = 0
    
    var body: some View {
        VStack {
            ZStack {
                Image("app_launch_img_1")
                    .rotationEffect(.degrees(rotationAngle))
                    .onAppear() {
                        withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                            self.rotationAngle = 360
                        }
                    }
                Image("app_launch_img_2")
            }
            Text("Weather Tracker".localizedString(key: "weather_tracker"))
                .font(.custom("Poppins-SemiBold", size: 24))
            if (launchVM.isNetworkError) {
                Text("No internet connection".localizedString(key: "no_internet_text"))
                    .font(.custom("Poppins-Regular", size: 12))
            } else {
                Text("Loading...".localizedString(key: "loading_text"))
                    .font(.custom("Poppins-Regular", size: 12))
            }
        }
        .onAppear {
            NetworkHandler.networkMonitorDelegate = launchVM
            launchVM.checkSavedLocation()
        }
        .alert(isPresented: $launchVM.shouldShowServerErrorAlert) {
            Alert(title: Text("Error".localizedString(key: "error_text")), message: Text("Something wrong with weather service".localizedString(key: "weather_service_error_text")))
        }
        .alert(isPresented: $launchVM.shouldShowNetworkAlert) {
            Alert(title: Text("Network Error".localizedString(key: "network_error")), message: Text("No internet connection".localizedString(key: "no_internet_text")))
        }
    }
}

#Preview {
    LaunchView()
}
