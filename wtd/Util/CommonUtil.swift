//
//  SceneDelegateUtil.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

final class CommonUtil {
    /// root view controller 변경 메소드
    static func changeRootView(to vc: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate {

            if let tabBarController = vc as? UITabBarController {
                sceneDelegate.window?.rootViewController = tabBarController
            } else {
                sceneDelegate.window?.rootViewController = vc
            }

            if let window = sceneDelegate.window {
                UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: { })
            }
        }
    }

    /// 저장된 API KEY 가져오는 메소드
    static func getApiKey(for name: ApiKeyNameConstant) -> String? {
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {

            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
                if let keys = plist as? [String: Any] {
                    let apiKey = keys[name.rawValue] as? String
                    return apiKey
                }
            } catch {
                print("❌ Error reading plist file: \(error)")
            }
        }
        return nil
    }

    /// 오늘 날짜 00월 00일 0요일 포맷
    static func getTodayDateWithFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일 EEEE" // 00/00/00 day
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }

    /// Doule타입 온도를 °C 기호가 붙은 String으로 포맷
    static func formatTeperatureToString(temperature: Double) -> String {
        return Int(temperature.rounded()).description + "°C"
    }

    /// Double타입 강수/강설량을 mm 기호가 붙은 String으로 포맷
    static func formatRainOrSnowAmountToString(amount: Double) -> String {
        return amount.description + "mm"
    }

    /// Double타입 풍속을 m/s 기호가 붙은 String으로 포맷
    static func formatWindSpeedToString(speed: Double) -> String {
        return speed.description + "m/s"
    }

    /// 낮, 밤 구분 로직
    static func checkMorningOrNight() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.dateFormat = "HH"
        let hour = Int(dateFormatter.string(from: Date()))

        if hour! >= 18 || hour! < 6 {
            return false
        } else {
            return true
        }
    }

    /// 00시 포맷
    static func formatHour(date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: date) else { return nil }

        dateFormatter.dateFormat = "HH시"
        let hour = dateFormatter.string(from: date)
        return hour
    }
    
    /// 시간만 추출 포맷
    static func formatOnlyHourNumber(date: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: date) else { return nil }
        
        dateFormatter.dateFormat = "HH"
        let hourNumber = dateFormatter.string(from: date)
        return Int(hourNumber)
    }

    /// 날씨 정보로 이미지명 가져오기
    static func getImageName(with weather: String, timeForTodayTomorrowView: Int?) -> String {
        if timeForTodayTomorrowView != nil {
            guard let hourNumber = timeForTodayTomorrowView else { return "" }
            let CONDITION = hourNumber >= 06 && hourNumber <= 18
            
            switch weather {
            case "Clear":
                return CONDITION ? "clear" : "moon"
            case "Rain":
                return "rain"
            case "Clouds":
                return CONDITION ? "cloud" : "moon_cloud"
            case "Snow":
                return "snow"
            case "Extreme":
                return "extreme"
            default:
                return CONDITION ? "haze" : "moon_cloud"
            }
        } else {
            let isDayTime: Bool = CommonUtil.checkMorningOrNight()

            switch weather {
            case "Clear":
                return isDayTime ? "clear" : "moon"
            case "Rain":
                return "rain"
            case "Clouds":
                return isDayTime ? "cloud" : "moon_cloud"
            case "Snow":
                return "snow"
            case "Extreme":
                return "extreme"
            default:
                return isDayTime ? "haze" : "moon_cloud"
            }
        }
    }

    /// 설정앱으로 이동
    static func movieToSettingApp() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    static func configureNavBar(for viewController: UIViewController) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        
        viewController.navigationController?.navigationBar.tintColor = .primary
        viewController.navigationItem.standardAppearance = appearance
        viewController.navigationItem.scrollEdgeAppearance = appearance
    }
}
