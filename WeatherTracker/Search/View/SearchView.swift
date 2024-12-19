//
//  SearchView.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var searchVM: SearchViewVM = SearchViewVM()
    
    var body: some View {
        ZStack {
            if (searchVM.shouldShowNetworkAlert) {
                VStack {
                    Text("Network Error".localizedString(key: "network_error"))
                        .font(.custom("Poppins-SemiBold", size: 15))
                    Text("No internet connection".localizedString(key: "no_internet_text"))
                        .font(.custom("Poppins-Regular", size: 16))
                }
            } else {
                if (searchVM.isSearching) {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    if #available(iOS 16.0, *) {
                        ScrollView {
                            if (searchVM.searchResults.isEmpty) {
                                Text("No results")
                                    .font(.custom("Poppins-SemiBold", size: 15))
                            } else {
                                ForEach(searchVM.searchResults, id: \.self) {
                                    city in
                                    SearchItemView(city: city)
                                        .onTapGesture {
                                            searchVM.didSelectCity(city)
                                        }
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    } else {
                        // Fallback on earlier versions
                        ScrollView(showsIndicators: false) {
                            if (searchVM.searchResults.isEmpty) {
                                Text("No results")
                                    .font(.custom("Poppins-SemiBold", size: 15))
                            } else {
                                ForEach(searchVM.searchResults, id: \.self) {
                                    city in
                                    SearchItemView(city: city)
                                        .onTapGesture {
                                            searchVM.didSelectCity(city)
                                        }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear() {
            NetworkHandler.networkMonitorDelegate = searchVM
        }
    }
}

#Preview {
    SearchView()
}
