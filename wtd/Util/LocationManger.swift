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

	override init() {
		super.init()

		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
		locationManager.requestAlwaysAuthorization()
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
	}

	// DID UPDATE
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			if let last = lastLocation, last.distance(from: location) < 1000 {
				
				locationManager.stopUpdatingLocation()
				print("1km 이상 위치가 변경되지 않았다면 사용자 위치를 업데이트 하지 않는다")
				return
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
				}

				print("locationManager didUpdateLocation")
			}
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
