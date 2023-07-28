//
//  WeatherModel.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/12.
//

import Foundation

/// 현재 날씨 =======================================
// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let rain: Rain?
    let snow: Snow?
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Rain
struct Rain: Codable {
    let rain1h: Double

    enum CodingKeys: String, CodingKey {
        case rain1h = "1h"
    }
}

// MARK: - Snow
struct Snow: Codable {
    let snow1h: Double

    enum CodingKeys: String, CodingKey {
        case snow1h = "1h"
    }
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}


//MARK: - API URL PATH ==================
enum WeatherQuery {
    case current
    case pollution
    case hourly
}
