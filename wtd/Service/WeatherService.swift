//
//  WeatherService.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/10.
//

import Foundation

final class WeatherService {
    static let shared = WeatherService()
    private init() { }
    let decoder = JSONDecoder()
    let session = URLSessionManager.shared.session

    /// 날씨 API 호출
    func getCurrentWeather(city: String?, lon: Double?, lat: Double?, completion: @escaping (WeatherResponse?) -> Void) {
        let urlRequest = URLRequest(router: ApiRouter.weather(query: WeatherQuery.current,
                                                              cnt: nil,
                                                              city: city,
                                                              longitude: lon,
                                                              latitude: lat,
                                                              requestMethod: "GET"))
        session?.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
            if let error = error {
                print("❌Error while get current weather with \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print("❌Error while get current weather with invalid response")
                completion(nil)
                return
            }

            guard (200...299).contains(response.statusCode) else {
                print("❌Error while get current weather with invalid status code")
                completion(nil)
                return
            }

            guard let data = data else {
                print("❌Error while get current weather with invalid data")
                completion(nil)
                return
            }

            
            do {
                let weatherData = try self?.decoder.decode(WeatherResponse.self, from: data)
                completion(weatherData)
            } catch {
                print("❌Error while get current weather with \(error.localizedDescription)")
                completion(nil)
            }

        })
        .resume()
    }

    /// 미세먼지 API 호출
    func getCurrentAirPollution(city: String?, lon: Double?, lat: Double?, completion: @escaping (DustResponse?) -> Void) {
        let urlRequest = URLRequest(router: ApiRouter.weather(query: WeatherQuery.pollution,
                                                              cnt: nil,
                                                              city: city,
                                                              longitude: lon,
                                                              latitude: lat,
                                                              requestMethod: "GET"))
        
        session?.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
            if let error = error {
                print("❌Error while get current air pollution with \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print("❌Error while get current air pollution with invalid response")
                completion(nil)
                return
            }

            guard (200...299).contains(response.statusCode) else {
                print("❌Error while get current air pollution with invalid status code")
                completion(nil)
                return
            }

            guard let data = data else {
                print("❌Error while get current air pollution with invalid data")
                completion(nil)
                return
            }

            do {
                let dustData = try self?.decoder.decode(DustResponse.self.self, from: data)
                completion(dustData)
            } catch {
                print("❌Error while get current air pollution with \(error.localizedDescription)")
                completion(nil)
            }
        })
        .resume()
    }

    /// 3시간별 날씨 API 호출
    func getHourlyWeather(city: String?, lon: Double?, lat: Double?, completion: @escaping (HourlyWeatherResponse?) -> Void) {
        let REQUEST_COUNT = 20
        let urlRequest = URLRequest(router: ApiRouter.weather(query: WeatherQuery.hourly,
                                                              cnt: REQUEST_COUNT,
                                                              city: city,
                                                              longitude: lon,
                                                              latitude: lat,
                                                              requestMethod: "GET"))
        
        session?.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
            if let error = error {
                print("Error while get hourly weather with \(error.localizedDescription) :::::::❌")
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print("❌Error while get hourly weather with invalid response")
                completion(nil)
                return
            }

            guard (200...299).contains(response.statusCode) else {
                print("❌Error while get hourly weather with invalid status code")
                completion(nil)
                return
            }

            guard let data = data else {
                print("❌Error while get hourly weather with invalid data")
                completion(nil)
                return
            }

            do {
                let hourlyData = try self?.decoder.decode(HourlyWeatherResponse.self.self, from: data)
                completion(hourlyData)
            } catch {
                print("❌Error while get hourly weather with \(error.localizedDescription)")
                completion(nil)
            }
        })
        .resume()
    }
}
