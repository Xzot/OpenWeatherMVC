//
//  OpenWeatherTestApp
//
// Created by Vlad Shchuka on 2024, All rights reserved.
//

import UIKit

class TabBarCustomTabView: UIView {
    @IBOutlet weak var tabBarImageView: UIImageView!
    @IBOutlet weak var tabBarLabel: UILabel!
    @IBAction func actionButtonClick(_ sender: UIButton) {
        buttonClickHandler?(type)
    }
    var type: TabBarItem!
    var buttonClickHandler: ((TabBarItem) -> Void)?
    
    var isSelected: Bool = false {
        didSet {
            tabBarImageView.tintColor = isSelected ? .link : .lightGray
            tabBarLabel.textColor = isSelected ? .link : .lightGray
        }
    }
}
