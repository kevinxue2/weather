//
//  Weather.swift
//  weather
//
//  Created by Kevin Xue on 2022-01-08.
//

import Foundation
public struct Weather {
    let city: String
    let temperature: String
    let description: String
    let iconName: String
    var daily: [Daily]
    var hourly: [Hourly]
    
    init(response: APIResponse) {
        city = cityName
        temperature = "\(Int(response.current.temp))"
        description = response.current.weather.first?.description ?? ""
        iconName = response.current.weather.first?.main ?? ""
        daily = []
        for x in response.daily {
            let weekday = Calendar.current.component(.weekday, from: x.dt)
            daily.append(Daily(min: String(Int(x.temp.min)), max: String(Int(x.temp.max)), icon: x.weather.first?.main ?? "", date: Calendar(identifier: .gregorian).weekdaySymbols[weekday-1]))
        }
        hourly = []
        for x in response.hourly {
            let hour = Calendar.current.component(.hour, from: x.dt)
            hourly.append(Hourly(temp: String(Int(x.temp)), icon: x.weather.first?.main ?? "", hour: String(hour)))
        }
    }
}

public struct Daily {
    var min: String
    var max: String
    var icon: String
    var date: String
}

public struct Hourly {
    var temp: String
    var icon: String
    var hour: String
}
