//
//  OpenWeatherTestApp
//
// Created by Vlad Shchuka on 2024, All rights reserved.
//

import UIKit

final class TabBarViewControllerContainer: UIViewController {
    @IBOutlet weak var tabBarViewsStackView: UIStackView!
    @IBOutlet weak var addNewCityButton: UIButton!
    
    private var myTabBarController: UITabBarController!
    private var tabBarItems: [TabBarCustomTabView] = TabBarItem.views
    private var selectedTabBarItem: TabBarItem = .main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarViewsSetup()
        tabBarSelectedItem(.main)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addNewCityButton.layer.cornerRadius = addNewCityButton.frame.height / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let tbc = segue.destination as? UITabBarController { myTabBarController = tbc }
    }
    
    private func tabBarViewsSetup() {
        myTabBarController.viewControllers = tabBarItems.map { $0.type.controller }
        tabBarItems.forEach { tabBarCustomTabView in
            tabBarCustomTabView.buttonClickHandler = { self.tabBarSelectedItem($0) }
            tabBarViewsStackView.addArrangedSubview(tabBarCustomTabView)
        }
    }
    
    private func tabBarSelectedItem(_ item: TabBarItem) {
        tabBarItems.forEach { $0.isSelected = false }
        selectedTabBarItem = item
        tabBarItems.forEach { $0.isSelected = ($0.type == item) }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        myTabBarController.selectedIndex = item.rawValue
    }
    
    @IBAction func addNewCityClick(_ sender: UIButton) {
        guard let navigationController = UIStoryboard(name: "AddCityViewController", bundle: .main).instantiateInitialViewController() else { return }
        present(navigationController, animated: true)
    }
}
