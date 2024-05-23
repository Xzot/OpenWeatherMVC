//
//  OpenWeatherTestApp
//
// Created by Vlad Shchuka on 2024, All rights reserved.
//

import UIKit

enum TabBarItem: Int, CaseIterable {
    case main, settings
    
    var image: UIImage? {
        switch self {
        case .main: return UIImage(systemName: "cloud")
        case .settings: return UIImage(systemName: "gear")
        }
    }
    
    var name: String {
        switch self {
        case .main: return "Main"
        case .settings: return "Settings"
        }
    }
    
    var controller: UIViewController {
        switch self {
        case .main:
            return UIStoryboard(name: "CityListViewController", bundle: .main).instantiateInitialViewController() ?? UIViewController()
        case .settings:
            return UIViewController()
        }
    }
}

extension TabBarItem {
    static var views: [TabBarCustomTabView] {
        return TabBarItem.allCases.map {
            let customTabView = TabBarCustomTabView.fromNib()
            customTabView.type = $0
            customTabView.tabBarImageView.image = $0.image
            customTabView.tabBarLabel.text = $0.name
            return customTabView
        }
    }
}
