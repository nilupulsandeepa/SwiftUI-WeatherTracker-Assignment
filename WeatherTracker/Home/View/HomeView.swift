//
//  HomeView.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewVM: HomeViewVM = HomeViewVM()
    
    private var debouncer: Debouncer = Debouncer()
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search Location".localizedString(key: "search_bar_placeholder"), text: $homeViewVM.searchTerm)
                    .font(.custom("Poppins-Regular", size: 15))
                    .autocorrectionDisabled()
                    .onChange(of: homeViewVM.searchTerm) { newValue in
                        debouncer.call {
                            Task {
                                homeViewVM.shouldShowSearchView = !newValue.isEmpty
                                try? await Task.sleep(nanoseconds: UInt64(0.5 * 1000000000))  //Intentional Delay
                                homeViewVM.searchTermChanged()
                            }
                        }
                    }
                Image(systemName: "magnifyingglass")
                    .renderingMode(.template)
                    .foregroundStyle(Color(hex: "#C4C4C4"))
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(hex: "#F2F2F2")))
            Spacer()
            if (homeViewVM.isWeatherAvailable && !homeViewVM.shouldShowSearchView) {
                WeatherHomeView(homeVM: homeViewVM)
            } else if (homeViewVM.shouldShowSearchView) {
                SearchView()
            } else if (!homeViewVM.isWeatherAvailable && !homeViewVM.shouldShowSearchView) {
                EmptyHomeView()
            }
            Spacer()
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    HomeView()
}
