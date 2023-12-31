//
//  LocationManger.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/11.
//

import CoreLocation
import UIKit

final class LocationManager: NSObject {
    //MARK: - properties ==================
    static let shared = LocationManager()
    let locationManager = CLLocationManager()
    var geocoder = CLGeocoder()

    var passLocationDatasForWeather: ((String?, String?, Double?, Double?) -> Void)?
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
}

//MARK: - func ==================
extension LocationManager {
    /// 위치 권한이 바뀔 때 위치 상태값 전달
    func postLocationAuthChangeNotification() {
        NotificationCenter.default.post(name: Notification.Name("locationAuthorizationChanged"),
                                        object: locationManager.authorizationStatus)
    }
}

//MARK: - CLLocationManagerDelegate ==================
extension LocationManager: CLLocationManagerDelegate {
    // DID UPDATE
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        // 최근 위치를 기반으로 도시명, 위도 경도 값을 구한다
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let weakSelf = self else { return }
            if let error = error {
                print("❌ Error while updating location with \(error.localizedDescription)")
                return
            }

            if let firstLocation = placemarks?[0] {
                let cityName = firstLocation.locality ?? "-"
                let countryName = firstLocation.country ?? "-"
                let lon = firstLocation.location?.coordinate.longitude ?? 0
                let lat = firstLocation.location?.coordinate.latitude ?? 0

                weakSelf.longitude = lon
                weakSelf.latitude = lat
                weakSelf.locationManager.stopUpdatingLocation()

                if weakSelf.isMapLocationUpdateRequest == false {
                    weakSelf.passLocationDatasForWeather?(cityName, countryName, lon, lat)

                }
            }
        }
    }

    // 위치 권한이 바뀔 때
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            CommonUtil.changeRootView(to: BaseTabBar())
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedAlways, .authorizedWhenInUse:
            isUpdatedAtSettingApp = true
            locationManager.startUpdatingLocation()
            break
        default:
            break
        }
        postLocationAuthChangeNotification()
    }

    // 위치 업데이트 실패 시
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
