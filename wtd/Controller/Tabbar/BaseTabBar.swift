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
    
    //MARK: - lifecycle ==================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabs()
    }
    
    //MARK: - FUNC ==================
    private func setTabs() {
        let weatherVC = WeatherVC(viewModel: weatherViewModel)
        let movieVC = MovieVC()
        let nearmeVC = NearMeVC()
        let profileVC = ProfileVC()
        
        let weatherNav = UINavigationController(rootViewController: weatherVC)
        let movieNav = UINavigationController(rootViewController: movieVC)
        let nearMeNav = UINavigationController(rootViewController: nearmeVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        weatherVC.tabBarItem.image = UIImage(systemName: "sun.max")
        weatherVC.tabBarItem.selectedImage = UIImage(systemName: "sun.max.fill")
        
        movieNav.tabBarItem.image = UIImage(systemName: "play.tv")
        movieNav.tabBarItem.selectedImage = UIImage(systemName: "play.tv.fill")
        
        nearMeNav.tabBarItem.image = UIImage(systemName: "map")
        nearMeNav.tabBarItem.selectedImage = UIImage(systemName: "map.fill")
        
        profileNav.tabBarItem.image = UIImage(systemName: "person")
        profileNav.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        tabBar.tintColor = UIColor.primary
        viewControllers = [weatherNav, movieNav, nearMeNav, profileNav]
    }
}

