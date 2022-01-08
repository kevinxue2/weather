//
//  ContentView.swift
//  Shared
//
//  Created by Kevin Xue on 2022-01-08.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .gray]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text(viewModel.cityName)
                    .font(.largeTitle)
                    .padding()
                Text(viewModel.temperature)
                    .font(.system(size: 70))
                    .bold()
                Text(viewModel.weatherIcon)
                    .font(.system(size: 70))
                Text(viewModel.weatherDescription)
                    .font(.system(size: 35))
                ScrollView{
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(0..<viewModel.hourly.count, id: \.self) {
                                    HourlyView(hourly: viewModel.hourly[$0])
                            }
                        }
                    }.padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(30)
                    ScrollView{
                        ForEach(0..<viewModel.daily.count, id: \.self) {
                                DailyView(daily: viewModel.daily[$0])
                        }
                    }.padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(30)
                }.cornerRadius(30)
                
            }.onAppear(perform: viewModel.refresh)
        }
    }
}

struct HourlyView: View {
    var hourly: Hourly
    var body: some View {
        VStack {
            Text(hourly.hour)
                .font(.system(.subheadline))
            Text(hourly.icon)
                .font(.system(.headline))
            Text(hourly.temp)
                .font(.subheadline)
        }
    }
}

struct DailyView: View {
    var daily: Daily
    var body: some View {
        HStack {
            Text(daily.date)
                .font(.system(.headline))
                .padding()
            Text(daily.icon)
                .font(.system(.headline))
                .padding()
            Text(daily.max)
                .font(.headline)
                .padding()
            Text(daily.min)
                .font(.headline)
                .padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel(weatherService: WeatherService()))
    }
}

