//
//  WeatherHomeView.swift
//  WeatherTracker
//
//  Created by Nilupul Sandeepa on 2024-12-16.
//

import SwiftUI

struct WeatherHomeView: View {
    @ObservedObject var homeVM: HomeViewVM
    var body: some View {
        ZStack {
            if (homeVM.shouldShowErrorView) {
                Text("Something wrong with weather service".localizedString(key: "weather_service_error_text"))
                    .font(.custom("Poppins-Medium", size: 12))
            } else {
                if (homeVM.isWeatherLoading) {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    VStack(spacing: 4) {
                        Spacer()
                            .frame(height: 74)
                        AsyncImage(
                            url: URL(string: "https:\(homeVM.currentWeather?.current.condition.icon.replacingOccurrences(of: "64x64", with: "128x128") ?? "")")
                        ) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 128, height: 128)
                            case .failure:
                                Image(systemName: "exclamationmark.triangle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 128, height: 128)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 128, height: 128)
                        HStack {
                            Spacer()
                            Text("\(homeVM.currentCity?.getCity() ?? "No City".localizedString(key: "no_city_text"))")
                                .font(.custom("Poppins-SemiBold", size: 30))
                            Image(systemName: "location.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 21)
                            Spacer()
                        }
                        ZStack {
                            Text("\(Int(homeVM.currentWeather?.current.tempC ?? 0))")
                                .font(.custom("Poppins-Medium", size: 70))
                            Image("degree_dot")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                                .transformEffect(CGAffineTransform.identity.translatedBy(x: 50, y: -30))
                        }
                        Spacer()
                            .frame(height: 36)
                        HStack {
                            VStack {
                                Text("Humidity".localizedString(key: "humidity_text"))
                                    .font(.custom("Poppins-Medium", size: 12))
                                    .foregroundStyle(Color(hex: "#C4C4C4"))
                                Text("\(Int(homeVM.currentWeather?.current.humidity ?? 0))%")
                                    .font(.custom("Poppins-Medium", size: 15))
                                    .foregroundStyle(Color(hex: "#9A9A9A"))
                            }
                            Spacer()
                            VStack {
                                Text("UV".localizedString(key: "uv_text"))
                                    .font(.custom("Poppins-Medium", size: 12))
                                    .foregroundStyle(Color(hex: "#C4C4C4"))
                                Text("\(Int(homeVM.currentWeather?.current.uv ?? 0))")
                                    .font(.custom("Poppins-Medium", size: 15))
                                    .foregroundStyle(Color(hex: "#9A9A9A"))
                            }
                            Spacer()
                            VStack {
                                Text("Feels Like".localizedString(key: "feels_like_text"))
                                    .font(.custom("Poppins-Medium", size: 12))
                                    .foregroundStyle(Color(hex: "#C4C4C4"))
                                ZStack {
                                    Text("\(Int(homeVM.currentWeather?.current.feelsLikeC ?? 0))")
                                        .font(.custom("Poppins-Medium", size: 15))
                                        .foregroundStyle(Color(hex: "#9A9A9A"))
                                    Image("degree_dot")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(Color(hex: "#C4C4C4"))
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 15)
                                        .transformEffect(CGAffineTransform.identity.translatedBy(x: 12, y: -8))
                                }
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color(hex: "#F2F2F2")))
                        .padding([.horizontal], 24)
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    WeatherHomeView(homeVM: HomeViewVM())
}
