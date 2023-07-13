//
//  WeatherViewModel.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/11.
//

import Foundation

class WeatherViewModel: NSObject {
    var cityName: String?
    var countryName: String?
    var longitude: Double?
    var latitude: Double?
    var locationManager = LocationManager()
    var todayDate = CommonUtil.getTodayDateWithFormat()
    var currentWeatherLoading = true {
        didSet {
            if currentWeatherLoading == false {
                DispatchQueue.main.async { [weak self] in
                    self?.afterFinishLoading?()
                }
            }
        }
    }
    var afterFinishLoading: (() -> Void)?


    override init() {
        super.init()

    }

    func setViewWithFetchData(completion: @escaping (WeatherResponse?, DustResponse?, String, String) -> Void) {
        locationManager.afterUpdateLocation = { [weak self] cityName, countryName, longitude, latitude in
            self?.cityName = cityName
            self?.countryName = countryName
            self?.longitude = longitude
            self?.latitude = latitude

            let group = DispatchGroup()
            var weatherResponse: WeatherResponse? = nil
            var dustResponse: DustResponse? = nil

            group.enter()
            self?.fetchCurrentWeather(city: nil, lon: longitude, lat: latitude) { res in
                weatherResponse = res
                group.leave()
            }
            
            group.enter()
            self?.fetchCurrentDust(city: nil, lon: longitude, lat: latitude, completion: { d_res in
                dustResponse = d_res
                group.leave()
            })

            group.notify(queue: .main) {
                guard let today = self?.todayDate, let city = cityName else { return }
                self?.currentWeatherLoading = false
                
                completion(weatherResponse, dustResponse, city, today)
            }
        }
    }

    func updateLocation() {
        locationManager.locationManager.startUpdatingLocation()
    }

    /// 현재 날씨 정보 호출
    fileprivate func fetchCurrentWeather(city: String?, lon: Double?, lat: Double?, completion: @escaping (WeatherResponse?) -> Void) {
        WeatherService.shared.getCurrentWeather(city: city, lon: lon, lat: lat) { response in
            if let res = response {
                print("🟢 SUCCESS FETCH CURRENT WEATHER")
                completion(res)
                return
            }
            completion(nil)
        }
    }

    /// 현재 미세먼지 정보 호출
    fileprivate func fetchCurrentDust(city: String?, lon: Double?, lat: Double?, completion: @escaping (DustResponse?) -> Void) {
        WeatherService.shared.getCurrentAirPollution(city: city, lon: lon, lat: lat) { response in
            if let res = response {
                print("🟢🟢 SUCCESS FETCH CURRENT AIR POLLUTION")
                completion(res)
                return
            }
            completion(nil)
        }
    }
}