//
//  weatherApp.swift
//  Shared
//
//  Created by Kevin Xue on 2022-01-08.
//

import SwiftUI

@main
struct weatherApp: App {
    var body: some Scene {
        WindowGroup {
            let weatherService = WeatherService()
            let viewModel = WeatherViewModel(weatherService: weatherService)
            ContentView(viewModel: viewModel)
        }
    }
}
