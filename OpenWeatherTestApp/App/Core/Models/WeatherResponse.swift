//
//  OpenWeatherTestApp
//
// Created by Vlad Shchuka on 2024, All rights reserved.
//

import Foundation

struct WeatherResponse: Decodable {
    let id: Double
    let coord: Coordinate
    let weather: [Weather]
    let main: Main
    let name: String // city name
}

struct Coordinate: Decodable {
    let lon, lat: Double
}

struct Weather: Decodable {
    let id: Int
    let main, description, icon: String
}

struct Main: Decodable {
    let temp: Double?
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let pressure: Double?
    let humidity: Double?
    let sea_level: Double?
    let grnd_level: Double?
}
