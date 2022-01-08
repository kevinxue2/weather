//
//  WeatherService.swift
//  weather
//
//  Created by Kevin Xue on 2022-01-08.
//

import CoreLocation
import Foundation

public var cityName = "Current Location"

public final class WeatherService : NSObject {
    private let locationManager = CLLocationManager()
    private let APIKey = "d5f891edf0d500515ae628f9cebd0ef8"
    private var completionHandler: ((Weather) -> Void)?
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func loadWeatherData(_ completionHandler: @escaping((Weather) -> Void)) {
        self.completionHandler = completionHandler
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        guard let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&exclude=minutely,alerts&appid=\(APIKey)&units=metric".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: urlString) else {return}
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        URLSession.shared.dataTask(with: url) {data, response, error in
            guard error == nil, let data = data else { return }
            if let response = try? decoder.decode(APIResponse.self, from: data) {
                self.completionHandler?(Weather(response: response))
            }
        }.resume()
    }
    
}

extension WeatherService: CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return }
        CLGeocoder().reverseGeocodeLocation(location) { placemark, error in
            guard let placemark = placemark else {
                print("Error:", error ?? "nil")
                return
            }
            cityName = placemark[0].locality ?? ""
        }
        self.makeDataRequest(forCoordinates: location.coordinate)
    }
    
    public func locationManager(
        _ manager : CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Something went wrong: \(error.localizedDescription)")
    }
}

struct APIResponse : Codable{
    struct Weather : Codable{
        let main: String
        let description: String
    }
    struct Current : Codable{
        let temp: Double
        let weather: [Weather]
    }
    
    struct Hourly : Codable{
        let dt: Date
        let temp: Double
        let weather: [Weather]
    }
    
    struct Daily : Codable{
        struct Temp : Codable{
            let min: Double
            let max: Double
        }
        let dt: Date
        let temp: Temp
        let weather: [Weather]
    }
    let current: Current
    let daily: [Daily]
    let hourly: [Hourly]
}
