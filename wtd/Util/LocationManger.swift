//
//  LocationManger.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/11.
//

import CoreLocation
import UIKit

final class LocationManager: NSObject, CLLocationManagerDelegate {
    //MARK: - properties ==================
    static let shared = LocationManager()

    let locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var authorizationStatus: CLAuthorizationStatus?
    var afterUpdateLocationUpdateWeatherDataWith: ((String?, String?, Double?, Double?) -> Void)?
    let updateInterval: TimeInterval = 5 * 60 // 5분
    var isUpdatedAtSettingApp = false
    var longitude: Double = 0
    var latitude: Double = 0
    var isMapLocationUpdateRequest: Bool = false

    //MARK: - lifecycle ==================
    private override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    //MARK: - func ==================
    // DID UPDATE
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        // 최근 위치를 기반으로 도시명, 위도 경도 값을 구한다
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("❌ Error while updating location with \(error.localizedDescription)")
                return
            }

            if let firstLocation = placemarks?[0] {
                let cityName = firstLocation.locality ?? "-"
                let countryName = firstLocation.country ?? "-"
                let lon = firstLocation.location?.coordinate.longitude ?? 0
                let lat = firstLocation.location?.coordinate.latitude ?? 0

                self?.longitude = lon
                self?.latitude = lat

                self?.locationManager.stopUpdatingLocation()

                guard let request = self?.isMapLocationUpdateRequest else { return }
                if request == false {
                    print("🐞🐞🐞 DEBUG - \n \(#file)파일 \(#line)줄 \(#function)함수 \n 이거 타면 날씨 API 호출 \n")
                    self?.afterUpdateLocationUpdateWeatherDataWith?(cityName, countryName, lon, lat)
                }
            }
        }
    }

    // DID CHANGE AUTH
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(manager.authorizationStatus.rawValue, "🔴🔴🔴🔴🔴🔴")
        switch manager.authorizationStatus {
        case .notDetermined:
            if authorizationStatus != nil {
                CommonUtil.changeRootView(to: BaseTabBar())
            }
            authorizationStatus = .notDetermined
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            authorizationStatus = .restricted
            break
        case .denied:
            authorizationStatus = .denied
            postNotification()
            break
        case .authorizedAlways:
            isUpdatedAtSettingApp = true
            authorizationStatus = .authorizedAlways
            locationManager.startUpdatingLocation()
            postNotification()
            break
        case .authorizedWhenInUse:
            isUpdatedAtSettingApp = true
            authorizationStatus = .authorizedWhenInUse
            locationManager.startUpdatingLocation()
            postNotification()
            break
        default:
            break
        }
    }

    // DID FAIL
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError {
            switch error.code {
            case .denied:
                print("❌ Error Location authorization denied with \(error)")
            case .network:
                print("❌ Error network with \(error)")
            default:
                print("❌ Error unknown location with \(error)")
            }
        } else {
            print("❌ Error while requesting locating with \(error)")
        }
    }
}


extension LocationManager {
    func postNotification() {
        NotificationCenter.default.post(name: Notification.Name("locationAuthorizationChanged"), object: authorizationStatus)
    }
}
