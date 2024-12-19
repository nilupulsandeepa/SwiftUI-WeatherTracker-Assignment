//
//  SearchItemView.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

import SwiftUI

struct SearchItemView: View {
    
    @StateObject var searchItemVM: SearchItemViewVM = SearchItemViewVM(searchService: SearchService())
    
    @State var city: City?
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("\(city?.getCity() ?? "")")
                    .font(.custom("Poppins-SemiBold", size: 20))
                Spacer()
                    .frame(height: 12)
                ZStack(alignment: .center) {
                    Text("\(searchItemVM.getTemperature())")
                        .font(.custom("Poppins-Medium", size: 60))
                        .frame(height: 55)
                    if (!searchItemVM.isLoading) {
                        Image("degree_dot")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .transformEffect(CGAffineTransform.identity.translatedBy(x: 40, y: -25))
                    }
                }
            }
            Spacer()
            ZStack {
                AsyncImage(
                    url: URL(string: "https:\(searchItemVM.weatherItem?.current.condition.icon.replacingOccurrences(of: "64x64", with: "128x128") ?? "")")
                ) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                    case .failure:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 80, height: 80)
            }
        }
        .padding([.horizontal], 24)
        .padding([.vertical], 16)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(hex: "#F2F2F2")))
        .onAppear() {
            searchItemVM.cityItem = city
            searchItemVM.fetchWeatherForSearchItem()
        }
    }
}

#Preview {
    SearchItemView()
}
