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
//    static func getApiKey(for name: ApiKeyNameConstant) -> String? {
//        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
//           let keys = NSDictionary(contentsOfFile: path) {
//
//            let apiKey = keys[name.rawValue] as? String
//            return apiKey
//        }
//        return nil
//    }
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
    
    // 오늘 날짜 00월 00일 0요일 포맷
    static func getTodayDateWithFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일 EEEE" // 00/00/00 day
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    
    // Doule타입 온도를 °C 기호가 붙은 String으로 포맷
    static func formatTeperatureToString(temperature: Double) -> String {
        return temperature.description + "°C"
    }
    
    // Double타입 강수/강설량을 mm 기호가 붙은 String으로 포맷
    static func formatRainOrSnowAmountToString(amount: Double) -> String {
        return amount.description + "mm"
    }
    
    // Double타입 풍속을 m/s 기호가 붙은 String으로 포맷
    static func formatWindSpeedToString(speed: Double) -> String {
        return speed.description + "m/s"
    }
}
