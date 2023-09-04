//
//  WeatherViewModel.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/11.
//

import Foundation

final class WeatherViewModel: NSObject {
    //MARK: - properties ==================
    var weatherResponse: WeatherResponse? = nil // 현재 날씨 데이터
    var dustResponse: DustResponse? = nil // 현재 미세먼지 데이터
    var hourlyResponse: HourlyWeatherResponse? = nil // 3시간별 날씨 데이터
    var todayThreeHourWeatherData: [HourlyList]? = nil // 오늘 3시간별 날씨 데이터
    var tomorrowThreeHourWeatherData: [HourlyList]? = nil // 내일 3시간별 날씨 데이터

    var cityName: String?
    var countryName: String?
    var longitude: Double?
    var latitude: Double?
    var todayDate = CommonUtil.getTodayDateWithFormat() // 오늘 날짜 MM-DD EEEE
    var afterFinishLoading: (() -> Void)? // 로딩이 종료되고 실행될 로직
    var currentWeatherLoading = true
    var isFetchFailed: Bool = false

    //MARK: - lifecycle ==================
    override init() {
        super.init()

        LocationManager.shared.locationManager.startUpdatingLocation()
    }
    
    //MARK: - func ==================
    /// 사용자 위치 정보로 응답받은 날씨 데이터를 뷰에 전달
    func injectFetchDataToViews(completion: @escaping (WeatherResponse?, DustResponse?, [HourlyList]?, [HourlyList]?, String, String?, Bool) -> Void) {
        LocationManager.shared.passLocationDatasForWeather = { [weak self] cityName, countryName, longitude, latitude in
            guard let weakSelf = self else { return }
            weakSelf.isFetchFailed = false
            weakSelf.currentWeatherLoading = true
            weakSelf.cityName = cityName
            weakSelf.countryName = countryName
            weakSelf.longitude = longitude
            weakSelf.latitude = latitude

            let group = DispatchGroup()
            group.enter()
            weakSelf.fetchCurrentWeather(city: nil, lon: longitude, lat: latitude) {
                group.leave()
            }

            group.enter()
            weakSelf.fetchCurrentDust(city: nil, lon: longitude, lat: latitude) {
                group.leave()
            }

            group.enter()
            weakSelf.fetchHourlyWeather(city: nil, lon: longitude, lat: latitude) {
                group.leave()
            }

            group.notify(queue: .main) { [weak self] in
                guard let weakSelf = self, let city = cityName else { return }
                weakSelf.currentWeatherLoading = false
                weakSelf.afterFinishLoading?()

                completion(weakSelf.weatherResponse,
                           weakSelf.dustResponse,
                           weakSelf.todayThreeHourWeatherData,
                           weakSelf.tomorrowThreeHourWeatherData,
                           city,
                           weakSelf.todayDate,
                           weakSelf.isFetchFailed)
            }
        }
    }
    
    /// 현재 날씨 정보 호출
    fileprivate func fetchCurrentWeather(city: String?, lon: Double?, lat: Double?, completion: @escaping () -> Void) {
        WeatherService.shared.getCurrentWeather(city: city, lon: lon, lat: lat) { [weak self] response in
            guard let weakSelf = self else { return }
            if let res = response {
                print("🟢 SUCCESS FETCH CURRENT WEATHER")
                weakSelf.weatherResponse = res
            } else {
                print("🔴 FAIL FETCH CURRENT WEATHER")
                weakSelf.isFetchFailed = true
            }
            completion()
        }
    }

    /// 현재 미세먼지 정보 호출
    fileprivate func fetchCurrentDust(city: String?, lon: Double?, lat: Double?, completion: @escaping () -> Void) {
        WeatherService.shared.getCurrentAirPollution(city: city, lon: lon, lat: lat) { [weak self] response in
            guard let weakSelf = self else { return }
            if let res = response {
                print("🟢🟢 SUCCESS FETCH CURRENT AIR POLLUTION")
                weakSelf.dustResponse = res
            } else {
                print("🔴 FAIL FETCH CURRENT AIR POLLUTION")
                weakSelf.isFetchFailed = true
            }
            completion()
        }
    }

    /// 오늘 내일 3시간별 예보 호출
    fileprivate func fetchHourlyWeather(city: String?, lon: Double?, lat: Double?, completion: @escaping () -> Void) {
        WeatherService.shared.getHourlyWeather(city: city, lon: lon, lat: lat) { [weak self] response in
            guard let weakSelf = self else { return }
            if let res = response {
                print("🟢🟢🟢 SUCCESS FETCH HOURLY WEATHER")
                weakSelf.hourlyResponse = res
                weakSelf.seperateTodayTomorrowWeatherData(from: res)
            } else {
                print("🔴 FAIL FETCH HOURLY WEATHER")
                weakSelf.isFetchFailed = true
            }
            completion()
        }
    }

    /// 오늘 | 내일 3시간 별 날씨 날짜 분리
    fileprivate func seperateTodayTomorrowWeatherData(from weatherData: HourlyWeatherResponse) {
        var todayData: [HourlyList] = []
        var tomorrowData: [HourlyList] = []
        let korTimezone = TimeZone(identifier: "Asia/Seoul")!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = korTimezone

        let fullNow = dateFormatter.string(from: Date())
        let fullTomorrow = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        
        let now = CommonUtil.extractYearMonthDay(dateStr: fullNow)
        let tomorrow = CommonUtil.extractYearMonthDay(dateStr: fullTomorrow)
        
        for data in weatherData.list {
            let fullWeatherDate = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(data.dt)))
            let weatherDate = CommonUtil.extractYearMonthDay(dateStr: fullWeatherDate)
            if now == weatherDate {
                todayData.append(data)
            } else if tomorrow == weatherDate {
                tomorrowData.append(data)
            }
        }

        todayThreeHourWeatherData = todayData
        tomorrowThreeHourWeatherData = tomorrowData
    }
}
