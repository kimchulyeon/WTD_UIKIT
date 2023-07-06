//
//  TabBar.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class BaseTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabs()
    }
    
    //MARK: - FUNC ==================
    private func setTabs() {
        let weatherVC = WeatherVC()
        let movieVC = MovieVC()
        let nearmeVC = NearMeVC()
        let profileVC = ProfileVC()
        
        let weatherNav = UINavigationController(rootViewController: weatherVC)
        let movieNav = UINavigationController(rootViewController: movieVC)
        let nearMeNav = UINavigationController(rootViewController: nearmeVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        weatherVC.tabBarItem.image = UIImage(systemName: "sun.max.circle")
        weatherVC.tabBarItem.selectedImage = UIImage(systemName: "sun.max.circle.fill")
        
        movieNav.tabBarItem.image = UIImage(systemName: "film.circle")
        movieNav.tabBarItem.selectedImage = UIImage(systemName: "film.circle.fill")
        
        nearMeNav.tabBarItem.image = UIImage(systemName: "map.circle")
        nearMeNav.tabBarItem.selectedImage = UIImage(systemName: "map.circle.fill")
        
        profileNav.tabBarItem.image = UIImage(systemName: "person.circle")
        profileNav.tabBarItem.selectedImage = UIImage(systemName: "person.circle.fill")
        
        tabBar.tintColor = UIColor.primary
        viewControllers = [weatherNav, movieNav, nearMeNav, profileNav]
    }
}

