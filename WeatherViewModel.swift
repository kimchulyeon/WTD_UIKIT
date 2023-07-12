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

    
    override init() {
        super.init()

    }

    func configureWithLocationData(completion: @escaping () -> Void) {
        locationManager.afterUpdateLocation = { [weak self] cityName, countryName, longitude, latitude in
            self?.cityName = cityName
            self?.countryName = countryName
            self?.longitude = longitude
            self?.latitude = latitude
            completion()
        }
    }

    func updateLocation() {
        locationManager.locationManager.startUpdatingLocation()
    }
}
