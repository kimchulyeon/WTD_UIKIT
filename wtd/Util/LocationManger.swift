//
//  LocationManger.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/11.
//

import CoreLocation
import UIKit

final class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var authorizationStatus: CLAuthorizationStatus?
    var afterUpdateLocation: ((String?, String?, Double?, Double?) -> Void)?
    var lastLocation: CLLocation?
    var isUpdateLocationAvailable = false
    var lastUpdatedTime: Date? = nil
    let updateInterval: TimeInterval = 60 * 5 // 5분

    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        forceUpdateLocationAfterFiveMin()
    }

    // 5분 뒤에 업데이트 가능하게 타이머 적용
    fileprivate func forceUpdateLocationAfterFiveMin() {
        lastUpdatedTime = Date()
        print("🌈 최초에 업데이트된 시간 : ", lastUpdatedTime ?? Date())

        Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            let now = Date()
            if let lastUpdatedTime = self.lastUpdatedTime,
                now.timeIntervalSince(lastUpdatedTime) >= self.updateInterval {

                isUpdateLocationAvailable = true
            }
        }
    }
    
    /// 업데이트가 가능한 상황인지 아닌지
    func canUpdateLocation() -> Bool {
        return isUpdateLocationAvailable
    }

    // DID UPDATE
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // 1km 이상 위치가 변경되지 않았다면
        if let last = lastLocation, last.distance(from: location) < 5000 {
            // 1km 이상 위치가 변경되지 않았더라도 updateInterval만큼 시간이 지났다면 위치를 업데이트할 수 있다
            if isUpdateLocationAvailable == false {
                locationManager.stopUpdatingLocation()
                print("5km 이상 위치가 변경되지 않았다면 사용자 위치를 업데이트 하지 않는다")
                return
            }
        }

        lastLocation = location

        locationManager.stopUpdatingLocation()

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

                self?.afterUpdateLocation?(cityName, countryName, lon, lat)
                self?.lastUpdatedTime = Date() // 마지막 업데이트된 시간 초기화
                self?.isUpdateLocationAvailable = false
                print("🔴 초기화된 시간 : ", self?.lastUpdatedTime ?? Date())
            }

            print("locationManager didUpdateLocation")
        }
    }

    // DID CHANGE AUTH
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationManager.requestLocation()
            authorizationStatus = .notDetermined
            break
        case .restricted:
            self.afterUpdateLocation?("서울특별시", "대한민국", 126.9918, 37.5518)
            authorizationStatus = .restricted
            break
        case .denied:
            self.afterUpdateLocation?("서울특별시", "대한민국", 126.9918, 37.5518)
            authorizationStatus = .denied
            break
        case .authorizedAlways:
            locationManager.requestLocation()
            authorizationStatus = .authorizedAlways
            break
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            authorizationStatus = .authorizedWhenInUse
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
                print("❌ Error Location authorization denied with \(error.localizedDescription)")
            case .network:
                print("❌ Error network with \(error.localizedDescription)")
            default:
                print("❌ Error unknown location with \(error.localizedDescription)")
            }
        } else {
            print("❌ Error while requesting locating with \(error.localizedDescription)")
        }
    }
}


extension LocationManager {
    func requestAgain() {

        switch authorizationStatus {
        case .notDetermined, .restricted, .denied:
            // 앱 설정 페이지로 이동
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case .authorizedAlways, .authorizedWhenInUse:
            // 위치 업데이트
            self.locationManager.startUpdatingLocation()
            break
        default:
            break
        }
    }
}
