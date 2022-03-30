//
//  MainAppViewController.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/9/21.
//
import UIKit

class MainAppViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        NavigationManager.instance.setupTabbarController(self)
        setupUI()
        setupTabbar()
    }
    
    private func setupUI() {
        tabBar.tintColor = UIColor.Primary
        tabBar.unselectedItemTintColor = UIColor.PrimaryUnselectTabbar
        tabBar.backgroundColor = UIColor.white
        tabBar.isTranslucent = false
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()

        tabBar.layer.shadowColor = UIColor.darkGray.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = .zero
        tabBar.layer.shadowRadius = 2
    }
    
    private func setupTabbar() {
        NavigationManager.instance.refreshTabbar()
    }
    
}

extension MainAppViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.lastIndex(of: viewController)
        switch index {
        default:
            UIApplication.shared.statusBarStyle = .lightContent
        }
        NavigationManager.instance.didSelectTabbar(index: index)
        return true
    }
}


