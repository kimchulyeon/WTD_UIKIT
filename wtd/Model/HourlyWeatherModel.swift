//
//  HourlyWeatherModel.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/17.
//

import Foundation

// MARK: - Welcome
struct HourlyWeatherResponse: Codable {
    let cod: String
    let message, cnt: Int
    let list: [HourlyList]
    let city: HourlyCity
}

// MARK: - City
struct HourlyCity: Codable {
    let id: Int
    let name: String
    let coord: HourlyCoord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct HourlyCoord: Codable {
    let lat, lon: Double
}

// MARK: - List
struct HourlyList: Codable {
    let dt: Int
    let main: HourlyMainClass
    let weather: [HourlyWeather]
    let clouds: HourlyClouds
    let wind: HourlyWind
    let visibility: Int
    let pop: Double
    let rain: HourlyRain?
    let sys: HourlySys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct HourlyClouds: Codable {
    let all: Int
}

// MARK: - MainClass
struct HourlyMainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct HourlyRain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct HourlySys: Codable {
    let pod: HourlyPod
}

enum HourlyPod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct HourlyWeather: Codable {
    let id: Int
    let main: String
    let description, icon: String
}


// MARK: - Wind
struct HourlyWind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

