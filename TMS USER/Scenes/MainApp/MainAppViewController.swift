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
        
        let homeVC = tabBarNavigation(unselectImage: UIImage(named: "home"), selectImage: UIImage(named: "home"), title: "สินค้าทั้งหมด", badgeValue: nil, navigationTitle: "", navigationOpeningSender: .home)

        let orderVC = tabBarNavigation(unselectImage: UIImage(named: "delivery"), selectImage: UIImage(named: "delivery"), title: "ออเดอร์", badgeValue: nil, navigationTitle: "", navigationOpeningSender: .order)

        let historyVC = tabBarNavigation(unselectImage: UIImage(named: "package"), selectImage: UIImage(named: "package"), title: "ประวัติการสั่งซื้อ", badgeValue: nil, navigationTitle: "", navigationOpeningSender: .history)

        let profileVC = tabBarNavigation(unselectImage: UIImage(named: "rating"), selectImage: UIImage(named: "rating"), title: "โปรไฟล์", badgeValue: nil, navigationTitle: "", navigationOpeningSender: .profile)
        
        viewControllers = [homeVC, orderVC, historyVC, profileVC]
    }
    
    
    fileprivate func tabBarNavigation(unselectImage: UIImage?, selectImage: UIImage?, title: String?, badgeValue: String?,navigationTitle: String?, navigationOpeningSender: NavigationOpeningSender) -> UINavigationController {
        
        let loadingStoryBoard = navigationOpeningSender.storyboardName
        let storyboard = UIStoryboard(name: loadingStoryBoard, bundle: nil)
        let rootViewcontroller = storyboard.instantiateInitialViewController()
        
        let navController = UINavigationController(rootViewController: rootViewcontroller ?? UIViewController())
        navController.tabBarItem.image = unselectImage
        navController.tabBarItem.selectedImage =  selectImage
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        navController.tabBarItem.title = title
        navController.tabBarItem.badgeColor = .red
        navController.tabBarItem.badgeValue = badgeValue
        navController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.PrimaryText(size: 11)], for: .normal)
        
        
        //navigationController
        rootViewcontroller?.navigationItem.title = navigationTitle ?? ""
        rootViewcontroller?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.PrimaryMedium(size: 18), NSAttributedString.Key.foregroundColor: UIColor.white]
        rootViewcontroller?.navigationController?.navigationBar.barTintColor = UIColor.Primary
        rootViewcontroller?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.bottom, barMetrics: .default)
        rootViewcontroller?.navigationController?.navigationBar.shadowImage = UIImage()
        rootViewcontroller?.navigationController?.navigationBar.isTranslucent = false
        rootViewcontroller?.navigationController?.navigationBar.barStyle = .black
        rootViewcontroller?.navigationController?.navigationBar.tintColor = .white
        
        return navController
    }
    
}


extension MainAppViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.lastIndex(of: viewController)
        
        return true
    }
}

