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

    /// 날씨 API 호출
    func getCurrentWeather(city: String?, lon: Double?, lat: Double?, completion: @escaping (WeatherResponse?) -> Void) {
        let session = URLSessionManager.shared.session
        let urlRequest = URLRequest(router: ApiRouter.weather(query: WeatherQuery.current, city: city, longitude: lon, latitude: lat, requestMethod: "GET"))
        session?.dataTask(with: urlRequest, completionHandler: { data, response, error in
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

            print(urlRequest)
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

            let decoder = JSONDecoder()
            do {
                let weatherData = try decoder.decode(WeatherResponse.self, from: data)
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
        let session = URLSessionManager.shared.session
        let urlRequest = URLRequest(router: ApiRouter.weather(query: WeatherQuery.pollution, city: city, longitude: lon, latitude: lat, requestMethod: "GET"))
        session?.dataTask(with: urlRequest, completionHandler: { data, response, error in
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

            print(urlRequest)
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

            let decoder = JSONDecoder()
            do {
                let dustData = try decoder.decode(DustResponse.self.self, from: data)
                completion(dustData)
            } catch {
                print("❌Error while get current air pollution with \(error.localizedDescription)")
                completion(nil)
            }
        })
        .resume()
    }
}
