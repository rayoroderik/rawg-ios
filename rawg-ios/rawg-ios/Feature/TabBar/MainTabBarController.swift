//
//  MainTabBarController.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    var currentSelectedTab = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabbar()
        
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = .systemBackground
            UITabBar.appearance().standardAppearance = tabBarAppearance
            
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
    
    func setupTabbar() {
        // Set tab tint (highlighted) color
        self.tabBar.tintColor = UIColor.systemBlue
        
        setupTabBarItem()
    }

    func setupTabBarItem() {
        // Create the first view controller and set its tab bar item
        let firstViewController = GameListViewController()
        let firstNavController = UINavigationController(rootViewController: firstViewController)
        firstViewController.tabBarItem = UITabBarItem(title: "Home",
                                                      image: UIImage(systemName: "house"),
                                                      tag: 0)

        // Create the second view controller and set its tab bar item
        let secondViewController = GameListViewController()
        let secondNavController = UINavigationController(rootViewController: secondViewController)
        secondViewController.tabBarItem = UITabBarItem(title: "Favorite",
                                                       image: UIImage(systemName: "heart"),
                                                       tag: 0)
        
        viewControllers = [firstNavController, secondNavController]
    }
    
    func setupShadowTabbar() {
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowColor = UIColor.secondaryLabel.cgColor
        tabBar.layer.shadowOpacity = 0.3
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let navigationController = viewController as? UINavigationController,
                navigationController.viewControllers.count <= 1,
                let handler = navigationController.viewControllers.first as? TabBarReselectHandling else { return true }
        handler.handleReselect()
        
        return true
    }
}

protocol TabBarReselectHandling {
    func handleReselect()
}
