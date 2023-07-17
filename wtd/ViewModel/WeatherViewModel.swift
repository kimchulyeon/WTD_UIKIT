//
//  WeatherViewModel.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/11.
//

import Foundation

class WeatherViewModel: NSObject {
    var weatherResponse: WeatherResponse? = nil
    var dustResponse: DustResponse? = nil
    var hourlyResponse: HourlyWeatherResponse? = nil
    
    var cityName: String?
    var countryName: String?
    var longitude: Double?
    var latitude: Double?
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

    /// 응답받은 데이터를 뷰에 전달
    func injectFetchDataToViews(completion: @escaping (WeatherResponse?, DustResponse?, HourlyWeatherResponse?, String, String) -> Void) {
        LocationManager.shared.afterUpdateLocation = { [weak self] cityName, countryName, longitude, latitude in
            guard let self = self else { return }
            
            self.cityName = cityName
            self.countryName = countryName
            self.longitude = longitude
            self.latitude = latitude
			
            let group = DispatchGroup()

            group.enter()
            self.fetchCurrentWeather(city: nil, lon: longitude, lat: latitude) { res in
                self.weatherResponse = res
                group.leave()
            }
            
            group.enter()
            self.fetchCurrentDust(city: nil, lon: longitude, lat: latitude, completion: { d_res in
                self.dustResponse = d_res
                group.leave()
            })
            
            group.enter()
            self.fetchHourlyWeather(city: nil, lon: longitude, lat: latitude) { h_res in
                self.hourlyResponse = h_res
                group.leave()
            }

            group.notify(queue: .main) {
                guard let city = cityName else { return }
                self.currentWeatherLoading = false
                
                completion(self.weatherResponse, self.dustResponse, self.hourlyResponse, city, self.todayDate)
            }
        }
    }
    
    /// 사용자 위치 업데이트 실행
    func updateLocation() {
        LocationManager.shared.locationManager.startUpdatingLocation()
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
    
    /// 오늘 내일 3시간별 예보 호출
    fileprivate func fetchHourlyWeather(city: String?, lon: Double?, lat: Double?, completion: @escaping (HourlyWeatherResponse?) -> Void) {
        WeatherService.shared.getHourlyWeather(city: city, lon: lon, lat: lat) { response in
            if let res = response {
                print("🟢🟢🟢 SUCCESS FETCH HOURLY WEATHER")
                completion(res)
                return
            }
            completion(nil)
        }
    }
}
