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
    var currentWeatherLoading = true { // 로딩 상태
        didSet {
            if currentWeatherLoading == false {
                DispatchQueue.main.async { [weak self] in
                    // WeatherVC에서 afterFinishLoading을 할당해주는 개념
                    self?.afterFinishLoading?()
                }
            }
        }
    }
    var afterFinishLoading: (() -> Void)? // 로딩이 종료되고 실행될 로직

    //MARK: - lifecycle ==================
    override init() {
        super.init()

    }
    
    //MARK: - func ==================
    /// 사용자 위치 정보로 응답받은 날씨 데이터를 뷰에 전달
    func injectFetchDataToViews(completion: @escaping (WeatherResponse?, DustResponse?, [HourlyList]?, [HourlyList]?, String, String?) -> Void) {
        LocationManager.shared.afterUpdateLocationUpdateWeatherDataWith = { [weak self] cityName, countryName, longitude, latitude in
            guard let self = self else { return }
            currentWeatherLoading = true

            self.cityName = cityName
            self.countryName = countryName
            self.longitude = longitude
            self.latitude = latitude

            let group = DispatchGroup()

            group.enter()
            self.fetchCurrentWeather(city: nil, lon: longitude, lat: latitude) {
                group.leave()
            }

            group.enter()
            self.fetchCurrentDust(city: nil, lon: longitude, lat: latitude) {
                group.leave()
            }

            group.enter()
            self.fetchHourlyWeather(city: nil, lon: longitude, lat: latitude) {
                group.leave()
            }

            group.notify(queue: .main) { [weak self] in
                guard let city = cityName else { return }
                self?.currentWeatherLoading = false

                completion(self?.weatherResponse, self?.dustResponse, self?.todayThreeHourWeatherData, self?.tomorrowThreeHourWeatherData, city, self?.todayDate)
            }
        }
    }

    /// 현재 날씨 정보 호출
    fileprivate func fetchCurrentWeather(city: String?, lon: Double?, lat: Double?, completion: @escaping () -> Void) {
        WeatherService.shared.getCurrentWeather(city: city, lon: lon, lat: lat) { response in
            if let res = response {
                print("🟢 SUCCESS FETCH CURRENT WEATHER")
                self.weatherResponse = res
                completion()
                return
            }
        }
    }

    /// 현재 미세먼지 정보 호출
    fileprivate func fetchCurrentDust(city: String?, lon: Double?, lat: Double?, completion: @escaping () -> Void) {
        WeatherService.shared.getCurrentAirPollution(city: city, lon: lon, lat: lat) { response in
            if let res = response {
                print("🟢🟢 SUCCESS FETCH CURRENT AIR POLLUTION")
                self.dustResponse = res
                completion()
                return
            }
        }
    }

    /// 오늘 내일 3시간별 예보 호출
    fileprivate func fetchHourlyWeather(city: String?, lon: Double?, lat: Double?, completion: @escaping () -> Void) {
        WeatherService.shared.getHourlyWeather(city: city, lon: lon, lat: lat) { [weak self] response in
            if let res = response {
                print("🟢🟢🟢 SUCCESS FETCH HOURLY WEATHER")
                self?.hourlyResponse = res
                self?.seperateTodayTomorrowWeatherData(from: res)
                completion()
                return
            }
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
        
        let now = extractYearMonthDay(dateStr: fullNow)
        let tomorrow = extractYearMonthDay(dateStr: fullTomorrow)
        
        for data in weatherData.list {
            let fullWeatherDate = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(data.dt)))
            let weatherDate = extractYearMonthDay(dateStr: fullWeatherDate)
            if now == weatherDate {
                todayData.append(data)
            } else if tomorrow == weatherDate {
                tomorrowData.append(data)
            }
        }

        todayThreeHourWeatherData = todayData
        tomorrowThreeHourWeatherData = tomorrowData
    }
    
    fileprivate func extractYearMonthDay(dateStr: String) -> String {
        return String(dateStr.split(separator: " ")[0])
    }
}
