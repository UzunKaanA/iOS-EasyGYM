//
//  TabBarViewController.swift
//  EasyGYM
//
//  Created by Kaan Uzun on 20.06.2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }

    private func setupTabBar() {
        // Customize the tab bar appearance
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false

        // Set up the tab bar items with custom titles and images
        let homeVC = viewControllers?[0]
        homeVC?.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))

        let libraryVC = viewControllers?[1]
        libraryVC?.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "books.vertical"), selectedImage: UIImage(systemName: "books.vertical.fill"))

        let profileVC = viewControllers?[2]
        profileVC?.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
    }
}
