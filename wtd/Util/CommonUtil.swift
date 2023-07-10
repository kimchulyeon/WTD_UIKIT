//
//  SceneDelegateUtil.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class CommonUtil {
    /// root view controller 변경 메소드
    static func changeRootView(to vc: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate {

            if let tabBarController = vc as? UITabBarController {
                sceneDelegate.window?.rootViewController = tabBarController
            } else {
                sceneDelegate.window?.rootViewController = vc
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
}
