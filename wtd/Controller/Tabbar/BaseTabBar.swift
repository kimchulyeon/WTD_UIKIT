//
//  TabBar.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class BaseTabBar: UITabBarController {
    //MARK: - properties ==================
    let weatherViewModel = WeatherViewModel()
    let movieViewModel = MovieViewModel()

    lazy var weatherVC: UIViewController = {
        let vc = WeatherVC(viewModel: weatherViewModel)
        vc.tabBarItem.image = UIImage(systemName: "sun.max")
        vc.tabBarItem.selectedImage = UIImage(systemName: "sun.max.fill")
        return UINavigationController(rootViewController: vc)
    }()

    lazy var movieVC: UIViewController = {
        let vc = MovieVC(viewModel: movieViewModel)
        vc.tabBarItem.image = UIImage(systemName: "play.tv")
        vc.tabBarItem.selectedImage = UIImage(systemName: "play.tv.fill")
        return UINavigationController(rootViewController: vc)
    }()
    lazy var nearMeVC: UIViewController = {
        let vc = NearMeVC()
        vc.tabBarItem.image = UIImage(systemName: "map")
        vc.tabBarItem.selectedImage = UIImage(systemName: "map.fill")
        return UINavigationController(rootViewController: vc)
    }()

    lazy var profileVC: UIViewController = {
        let vc = ProfileVC()
        vc.tabBarItem.image = UIImage(systemName: "gearshape")
        vc.tabBarItem.selectedImage = UIImage(systemName: "gearshape.fill")
        return UINavigationController(rootViewController: vc)
    }()

    //MARK: - lifecycle ==================
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTabs()
    }
    
    deinit {
        print("BASE TAB BAR DEINIT ❌❌❌")
    }

    //MARK: - FUNC ==================
    private func setTabs() {
        viewControllers = [weatherVC, movieVC, nearMeVC, profileVC]
    }
}

