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
}
