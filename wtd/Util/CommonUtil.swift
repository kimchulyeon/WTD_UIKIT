//
//  SceneDelegateUtil.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class CommonUtil {
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
}
