//
//  WeatherViewModel.swift
//  weather
//
//  Created by Kevin Xue on 2022-01-08.
//

import Foundation
private let defaultIcon = "?"
private let iconMap = [
    "Drizzle" : "🌦",
    "Thunderstorm" : "⛈",
    "Rain" : "🌧",
    "Snow" : "❄️",
    "Clear" : "☀️",
    "Clouds" : "☁️"]
private let hourMap = [0: "AM", 1: "PM"]

public class WeatherViewModel: ObservableObject {
    @Published var cityName: String = "City Name"
    @Published var temperature: String = "--"
    @Published var weatherDescription: String = "--"
    @Published var weatherIcon: String = defaultIcon
    @Published var daily: [Daily] = []
    @Published var hourly: [Hourly] = []
    
    public let weatherService: WeatherService
    
    public init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    public func refresh() {
        weatherService.loadWeatherData { weather in
            DispatchQueue.main.async {
                self.cityName = weather.city
                self.temperature = "\(weather.temperature)°C"
                self.weatherDescription = weather.description.capitalized
                self.weatherIcon = iconMap[weather.iconName] ?? defaultIcon
                self.daily = []
                for x in 1..<weather.daily.count {
                    var y = weather.daily[x]
                    y.min = "L: \(y.min)°C"
                    y.max = "H: \(y.max)°C"
                    y.icon = iconMap[y.icon] ?? defaultIcon
                    self.daily.append(y)
                }
                self.hourly = []
                for x in 1..<weather.hourly.count {
                    var y = weather.hourly[x]
                    y.temp = "\(y.temp)°C"
                    y.icon = iconMap[y.icon] ?? defaultIcon
                    y.hour = "\(self.conv12(num: Int(y.hour) ?? 0)) \(hourMap[(Int(y.hour) ?? 0)/12] ?? "AM")"
                    self.hourly.append(y)
                }
            }
        }
    }
    
    private func conv12(num: Int) -> Int {
        if num%12 == 0 {
            return 12
        }
        else {return num%12}
    }
}
