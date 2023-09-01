//
//  SceneDelegateUtil.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

final class CommonUtil {
    /// 기본 배경, 탭바 구성
    static func configureBasicView(for viewController: UIViewController) {
        viewController.view.backgroundColor = UIColor.myWhite
        // iphone 12 pro max에서 탭바 배경색 변경
        viewController.tabBarController?.tabBar.isTranslucent = false
        viewController.tabBarController?.tabBar.backgroundColor = UIColor.myWhite
        viewController.tabBarController?.tabBar.barTintColor = UIColor.myWhite
        // iphone 12 pro max에서 탭바 상단 선 제거
        viewController.tabBarController?.tabBar.shadowImage = UIImage()
        viewController.tabBarController?.tabBar.backgroundImage = UIImage()
    }

    /// 공통 네비게이션 바 설정
    static func configureNavBar(for viewController: UIViewController) {
        let appearance = UINavigationBarAppearance()

        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.myWhite.withAlphaComponent(0.97)

        viewController.navigationController?.navigationBar.tintColor = .primary
        viewController.navigationItem.standardAppearance = appearance
        viewController.navigationItem.scrollEdgeAppearance = appearance
    }

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
                guard let keys = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else { return nil }
                let apiKey = keys[name.rawValue] as? String
                return apiKey
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

    /// yyyy-MM-dd HH:mm:ss  =>  yyyy-MM-dd 변환
    static func extractYearMonthDay(dateStr: String) -> String {
        return String(dateStr.split(separator: " ")[0])
    }

    /// 시간만 추출 포맷
    static func formatOnlyHourNumber(date: Int) -> String {
        let timeInterval = TimeInterval(date)
        let date = Date(timeIntervalSince1970: timeInterval)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        let hour = dateFormatter.string(from: date)
        return hour
    }

    /// 날씨 정보로 이미지명 가져오기
    static func getWeatherImageName(with weather: String, timeForTodayTomorrowView: Int?) -> String {
        if timeForTodayTomorrowView != nil {
            guard let hourNumber = timeForTodayTomorrowView else { return "" }
            let isDayTime = hourNumber >= 06 && hourNumber <= 18

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

    /// 유튜브 영상 full path
    static func formatFullVideoUrl(url: String) -> String {
        return "https://www.youtube.com/watch?v=" + url
    }

    /// 다른 앱으로 이동
    static func moveAnotherApp(url: String, appId: String?) {
        guard let appURL = URL(string: url) else { return }
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            showAlert(title: "앱이 설치되어 있지 않습니다", message: "앱스토어로 연결됩니다", actionTitle: "다운로드", actionStyle: .destructive) { _ in
                guard let id = appId, let appStoreURL = URL(string: "https://apps.apple.com/app/\(id)") else { return }
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            } cancelHandler: { _ in
                print("cancel:::::")
            }

        }
    }

    /// 알럿 띄우기
    static func showAlert(title: String?, message: String?, type: UIAlertController.Style = .alert, actionTitle: String?, actionStyle: UIAlertAction.Style?, actionHandler: ((UIAlertAction) -> Void)?, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: type)

        if let actionTitle = actionTitle, let actionHandler = actionHandler, let actionStyle = actionStyle {
            let action = UIAlertAction(title: actionTitle, style: actionStyle, handler: actionHandler)
            alertController.addAction(action)
        }

        if cancelHandler != nil {
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: cancelHandler)
            alertController.addAction(cancelAction)
        }

        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        var nowPresentedViewController: UIViewController?
        guard let rootViewController = window?.rootViewController else { return }
        nowPresentedViewController = rootViewController // rootViewController의 presentedViewController가 nil인 경우도 있기 때문
        while let viewController = rootViewController.presentedViewController {
            nowPresentedViewController = viewController
        }

        nowPresentedViewController?.present(alertController, animated: true, completion: nil)
    }

    /// 전화 연결
    static func callNumber(phoneNumber: String) {
        if let phoneURL = URL(string: "tel://\(phoneNumber)") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL)
            } else {
                print("Fail to call")
            }
        }
    }

    /// formsheet 형태 webView
    static func openFormSheetWebView(at viewController: UIViewController, url: String) {
        let webVC = WebVC()
        webVC.modalPresentationStyle = .formSheet
        webVC.sheetPresentationController?.prefersGrabberVisible = true
        webVC.urlString = url
        viewController.navigationController?.present(webVC, animated: true)
    }
}
