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
    var afterUpdateLocation: ((String?, String?, Double?, Double?) -> Void)?
    var lastLocation: CLLocation?
    var isUpdateLocationAvailable = false
    var lastUpdatedTime: Date? = nil
    let updateInterval: TimeInterval = 5 * 60 // 5분
	var isUpdatedAtSettingApp = false
    var longitude: Double = 0
    var latitude: Double = 0

    //MARK: - lifecycle ==================
    private override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        forceUpdateLocationAfterFiveMin()
    }

    //MARK: - func ==================
    // DID UPDATE
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let now = Date()
        let timeSinceLastUpated = lastUpdatedTime != nil ? now.timeIntervalSince(lastUpdatedTime!) : updateInterval
        
        print("마지막 위치 업데이트로 부터 흐른 시간 : \(timeSinceLastUpated) :::::::🚀")
        
        // 5km 이상 위치가 변경되지 않았다면
        if let last = lastLocation, last.distance(from: location) < 5000, timeSinceLastUpated < updateInterval && !isUpdatedAtSettingApp {
            // 5분이상 지나야 위치 업데이트 가능
            if !isUpdateLocationAvailable && (authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse) {
                locationManager.stopUpdatingLocation()
                print("5km 이상 위치가 변경되지 않았다면 사용자 위치를 업데이트 하지 않는다")
                return
            }
        }
        
        // 최근 위치를 저장하고 위치 업데이트를 종료
        lastLocation = location
        locationManager.stopUpdatingLocation()

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

                self?.afterUpdateLocation?(cityName, countryName, lon, lat)
                self?.lastUpdatedTime = Date() // 마지막 업데이트된 시간 초기화
                self?.isUpdateLocationAvailable = false
            }
        }
    }

    // DID CHANGE AUTH
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            authorizationStatus = .notDetermined
            locationManager.requestLocation()
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
            locationManager.requestLocation()
            postNotification()
            break
        case .authorizedWhenInUse:
			isUpdatedAtSettingApp = true
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
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
    /// 5분 뒤에 업데이트 가능하게 타이머 적용
    private func forceUpdateLocationAfterFiveMin() {
        lastUpdatedTime = Date()

        Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            let now = Date()
            if let lastUpdatedTime = lastUpdatedTime,
                now.timeIntervalSince(lastUpdatedTime) >= updateInterval {

                isUpdateLocationAvailable = true
            }
        }
    }
    
    /// 업데이트가 가능한 상황인지 아닌지
    func canUpdateLocation() -> Bool {
        return isUpdateLocationAvailable
    }
    
    func postNotification() {
        NotificationCenter.default.post(name: Notification.Name("locationAuthorizationChanged"), object: authorizationStatus)
    }
}
