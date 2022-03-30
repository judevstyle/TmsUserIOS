//
//  NavigationManager.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 5/15/21.
//

import Foundation
import UIKit
import MaterialComponents

public enum NavigationOpeningSender {
    case splash
    case intro
    case login
    case register
    
    //Main Tabbar
    case mainApp
    case home
    case order
    case history
    case profile
    
    //Cart
    case productCart(dismiss: (() -> Void)? = nil)
    
    //Modal
    case productDetailBottomSheet(item: ProductItems?, delegate: ProductDetailBottomSheetViewModelDelegate)
    case productDetail(item: ProductItems?, delegate: ProductDetailViewModelDelegate)
    
    //OrderDetail
    case orderDetail(orderId: Int?)
    
    //OrderTracking
    case orderTracking(orderId: Int?)
    
    case chat(orderId: Int?, items: RoomChatCustomerData?)
    
    case selectCurrentLocation(delegate: SelectCurrentLocationViewControllerDelegate)
    
    case manageProfile
    
    public var storyboardName: String {
        switch self {
        case .splash:
            return "Splash"
        case .intro:
            return "Intro"
        case .login:
            return "Login"
        case .register:
            return "Register"
        case .mainApp:
            return "MainApp"
        case .home:
            return "Home"
        case .order:
            return "Order"
        case .history:
            return "History"
        case .profile:
            return "Profile"
        case .productCart:
            return "ProductCart"
        case .productDetailBottomSheet:
            return "ProductDetailBottomSheet"
        case .orderDetail:
            return "OrderDetail"
        case .orderTracking:
            return "OrderTracking"
        case .chat:
            return "Chat"
        case .productDetail:
            return "ProductDetail"
        case .selectCurrentLocation:
            return "SelectCurrentLocation"
        case .manageProfile:
            return "ManageProfile"
        }
    }
    
    public var classNameString: String {
        switch self {
        case .splash:
            return "SplashViewController"
        case .intro:
            return "IntroViewController"
        case .login:
            return "LoginViewController"
        case .register:
            return "RegisterViewController"
        case .mainApp:
            return "MainAppViewController"
        case .home:
            return "HomeViewController"
        case .order:
            return "OrderViewController"
        case .history:
            return "HistoryViewController"
        case .profile:
            return "ProfileViewController"
        case .productCart:
            return "ProductCartViewController"
        case .productDetailBottomSheet:
            return "ProductDetailBottomSheetViewController"
        case .orderDetail:
            return "OrderDetailViewController"
        case .orderTracking:
            return "OrderTrackingViewController"
        case .chat:
            return "ChatViewController"
        case .productDetail:
            return "ProductDetailViewController"
        case .selectCurrentLocation:
            return "SelectCurrentLocationViewController"
        case .manageProfile:
            return "ManageProfileViewController"
        }
    }
    
    public var viewController: UIViewController {
        switch self {
        default:
            return UIViewController()
        }
    }
    
    public var titleNavigation: String {
        switch self {
        case .order:
            return "รอการจัดส่ง"
        case .productCart:
            return "ตะกร้าสินค้า"
        case .orderDetail:
            return "รายละเอียดการสั่งซื้อ"
        case .orderTracking:
            return "ติดตามคำสั่งซื้อ"
        case .selectCurrentLocation:
            return "เลือก Location"
        case .history:
            return "ประวัติการสั่งซื้อ"
        default:
            return ""
        }
    }
    
    public var navController: UINavigationController {
        
        let loadingStoryBoard = self.storyboardName
        let storyboard = UIStoryboard(name: loadingStoryBoard, bundle: nil)
        let rootViewcontroller = storyboard.instantiateInitialViewController()
        let navController = UINavigationController(rootViewController: rootViewcontroller ?? UIViewController())
        rootViewcontroller?.navigationItem.title = titleNavigation
        rootViewcontroller?.hideKeyboardWhenTappedAround()
        
        if let vc = rootViewcontroller {
            NavigationManager.instance.setupWithNavigationController(vc)
        }
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            
            switch self {
            case .profile, .manageProfile:
                appearance.backgroundColor = .clear
            default:
                appearance.backgroundColor = .Primary
            }
            appearance.shadowColor = .clear
            appearance.shadowImage = UIImage()
            appearance.backgroundImage = UIImage()
            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.PrimaryText(size: 16), NSAttributedString.Key.foregroundColor: UIColor.white]
            
            rootViewcontroller?.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            rootViewcontroller?.navigationController?.navigationBar.standardAppearance = appearance
            rootViewcontroller?.navigationController?.navigationBar.compactAppearance = appearance
        } else {
            
            rootViewcontroller?.navigationController?.navigationBar.barTintColor = UIColor.Primary
            rootViewcontroller?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.bottom, barMetrics: .default)
            rootViewcontroller?.navigationController?.navigationBar.shadowImage = UIImage()
            rootViewcontroller?.navigationController?.navigationBar.isTranslucent = true
            rootViewcontroller?.navigationController?.navigationBar.isHidden = true
            rootViewcontroller?.navigationController?.navigationBar.barStyle = .black
            rootViewcontroller?.navigationController?.navigationBar.tintColor = .white
            rootViewcontroller?.navigationController?.navigationBar.layoutIfNeeded()
        }
        
        rootViewcontroller?.navigationController?.navigationBar.tintColor = .white
        
        switch self {
        default:
            return navController
        }
    }
    
    public var navColor: UIColor {
        switch self {
        case .splash, .selectCurrentLocation:
            return .Primary
        default:
            return .clear
        }
    }
    
    public var tintColorBackButton: UIColor {
        switch self {
        case .register:
            return .Primary
        default:
            return .white
        }
    }
}

class NavigationManager {
    static let instance:NavigationManager = NavigationManager()
    
    var navigationController: UINavigationController!
    var rootViewController: UIViewController!
    var currentPresentation: Presentation = .Root
    var mainTabBarController: UITabBarController!
    public var lastIndexTabbar: Int = 0
    public var selectedIndexTabbar: Int = 0
    
    enum Presentation {
        case Root
        case Replace
        case Push
        case ModalNoNav(completion: (() -> Void)?)
        case ModelNav(completion: (() -> Void)?, isFullScreen: Bool)
        case BottomSheet(completion: (() -> Void)?, height: CGFloat)
        case PopupSheet(completion: (() -> Void)?)
        case presentFullScreen(completion: (() -> Void)?)
        case switchTabbar(index: Int)
        
    }
    
    init() {
        
    }

    
    func setupWithNavigationController(_ vc: UIViewController?) {
        if let nav = vc?.navigationController {
            self.navigationController = nav
        }
        
        if let vc = vc {
            self.rootViewController = vc
        }
    }
    
    func setupTabbarController(_ tabbar: UITabBarController?) {
        self.mainTabBarController = tabbar
    }
    
    func refreshTabbar() {
        let homeVC = getTabbarNavigation(logoImage: "home", title: "สินค้าทั้งหมด", sender: .home)
        let orderVC = getTabbarNavigation(logoImage: "delivery", title: "รอจัดส่ง", sender: .order)
        let historyVC = getTabbarNavigation(logoImage: "package", title: "ประวัติการสั่งซื้อ", sender: .history)
        let profileVC = getTabbarNavigation(logoImage: "rating", title: "โปรไฟล์", sender: .profile)

        self.mainTabBarController.viewControllers = [homeVC, orderVC, historyVC, profileVC]
    }
    
    private func getTabbarNavigation(logoImage: String, title: String, sender: NavigationOpeningSender) -> UINavigationController {
      return  tabBarNavigation(unselectImage: UIImage(named: logoImage), selectImage: UIImage(named: logoImage), title: title, badgeValue: nil, navigationTitle: "", navigationOpeningSender: sender)
    }
    
    fileprivate func tabBarNavigation(unselectImage: UIImage?, selectImage: UIImage?, title: String?, badgeValue: String?,navigationTitle: String?, navigationOpeningSender: NavigationOpeningSender) -> UINavigationController {

        let navController = navigationOpeningSender.navController
        navController.tabBarItem.image = unselectImage
        navController.tabBarItem.selectedImage =  selectImage
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: 2, right: 0)
        navController.tabBarItem.title = title
        navController.tabBarItem.badgeColor = .red
        navController.tabBarItem.badgeValue = badgeValue
        navController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.PrimaryText(size: 16)], for: .normal)
        return navController
    }
    
    
    
    func pushVC(to: NavigationOpeningSender, presentation: Presentation = .Push, isHiddenNavigationBar: Bool = false) {
        let loadingStoryBoard = to.storyboardName
        
        let storyboard = UIStoryboard(name: loadingStoryBoard, bundle: nil)
        var viewController: UIViewController = UIViewController()
        
        switch to {
        case .productDetailBottomSheet(let items, let delegate):
            if let className = storyboard.instantiateInitialViewController() as? ProductDetailBottomSheetViewController {
                className.viewModel.input.setProductItems(items: items)
                className.viewModel.input.setDelegate(delegate: delegate)
                viewController = className
            }
        case .productDetail(let items, let delegate):
            if let className = storyboard.instantiateInitialViewController() as? ProductDetailViewController {
                className.viewModel.input.setProductItems(items: items)
                className.viewModel.input.setDelegate(delegate: delegate)
                viewController = className
            }
        case .productCart(let dismiss):
            if let className = storyboard.instantiateInitialViewController() as? ProductCartViewController {
                className.dismiss = dismiss
                viewController = className
            }
        case .orderDetail(let orderId):
            if let className = storyboard.instantiateInitialViewController() as? OrderDetailViewController {
                className.viewModel.input.setOrderId(orderId: orderId)
                viewController = className
            }
        case .orderTracking(let orderId):
            if let className = storyboard.instantiateInitialViewController() as? OrderTrackingViewController {
                className.viewModel.input.setOrderId(orderId: orderId)
                viewController = className
            }
        case .chat(let orderId, let items):
            if let className = storyboard.instantiateInitialViewController() as? ChatViewController {
                className.viewModel.input.setOrderId(orderId: orderId)
                className.viewModel.input.setRoomChatCustomer(items: items)
                viewController = className
            }
        case .selectCurrentLocation(let delegate):
            if let className = storyboard.instantiateInitialViewController() as? SelectCurrentLocationViewController {
                className.delegate = delegate
                viewController = className
            }
        default:
            viewController = storyboard.instantiateInitialViewController() ?? to.viewController
        }
        
        viewController.navigationItem.title = to.titleNavigation
        
        viewController.hideKeyboardWhenTappedAround()
        
        self.presentVC(viewController: viewController, presentation: presentation, isHiddenNavigationBar: isHiddenNavigationBar, to: to)
    }
    
    private func presentVC(viewController: UIViewController, presentation: Presentation, isHiddenNavigationBar: Bool = false, to: NavigationOpeningSender, animated: Bool = true) {
        if let nav = self.navigationController {
            nav.isNavigationBarHidden = isHiddenNavigationBar
        }
        switch presentation {
        case .Push:
            if (self.navigationController.tabBarController != nil) {
                viewController.hidesBottomBarWhenPushed = true
            }
            self.pushViewController(vc: viewController, animated: animated, to: to)
        case .Root:
            let storyboard = UIStoryboard(name: to.storyboardName, bundle: nil)
            let initialViewController = storyboard.instantiateInitialViewController()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        case .ModalNoNav(let completion):
            let vc: UIViewController = viewController
            self.navigationController.present(vc, animated: true, completion: completion)
        case .Replace:
            var viewControllers = Array(self.navigationController.viewControllers.dropLast())
            viewControllers.append(viewController)
            self.navigationController.setViewControllers(viewControllers, animated: true)
        case .ModelNav(let completion, let isFullScreen):
            let nav: UINavigationController = getNavigationController(vc: viewController, isTranslucent: false, isFullScreen: isFullScreen)
            self.navigationController.present(nav, animated: true, completion: completion)
        case .BottomSheet(let completion, let height):
            viewController.view.setRounded(rounded: 20)
            let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: viewController)
            bottomSheet.preferredContentSize = CGSize(width: viewController.view.frame.size.width, height: height)
            bottomSheet.view.setRounded(rounded: 20)
            self.navigationController.present(bottomSheet, animated: true, completion: completion)
        case .PopupSheet(completion: let completion):
            viewController.view.backgroundColor = UIColor.blackAlpha(alpha: 0.2)
            viewController.modalPresentationStyle = .overFullScreen
            viewController.modalTransitionStyle = .crossDissolve
            self.navigationController.present(viewController, animated: true, completion: completion)
        case .presentFullScreen(let completion):
            let nav: UINavigationController = self.getNavigationController(vc: viewController, to: to)
            nav.view.backgroundColor = UIColor.black
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            let topVC = UIApplication.getTopViewController()
            topVC?.present(nav, animated: true, completion: completion)
        case .switchTabbar(index: let index):
            self.mainTabBarController.selectedIndex = index
        }
        self.currentPresentation = presentation
    }
    
    func switchTabbar(index: Int) {
        self.presentVC(viewController: UIViewController(), presentation: .switchTabbar(index: index), to: .splash)
    }
    
    func switchLastTabbar() {
        self.presentVC(viewController: UIViewController(), presentation: .switchTabbar(index: self.lastIndexTabbar), to: .splash)
        didSelectTabbar(index: self.lastIndexTabbar)
    }
    
    func didSelectTabbar(index: Int?) {
        if let index = index {
            lastIndexTabbar = selectedIndexTabbar
            selectedIndexTabbar = index
        }
    }
    
    func pushViewController(vc: UIViewController, animated: Bool, to: NavigationOpeningSender) {
        let topVC = UIApplication.getTopViewController()
        if let nav = topVC?.navigationController {
            nav.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            nav.navigationBar.tintColor = to.tintColorBackButton
            nav.pushViewController(vc, animated: animated)
        } else {
            self.navigationController.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController.navigationBar.tintColor = to.tintColorBackButton
            self.navigationController.pushViewController(vc, animated: animated)
        }
    }
    
    func setRootViewController(rootView: NavigationOpeningSender, withNav: Bool = true, isTranslucent: Bool = false, isAnimate: Bool = false, options: UIView.AnimationOptions = .curveEaseIn) {
        if isAnimate == true {
            UIView.transition(
                 with: UIApplication.shared.keyWindow!,
                 duration: 0.25,
                 options: options,
                 animations: {
                    let storyboard = UIStoryboard(name: rootView.storyboardName, bundle: nil)
                    if let vc = storyboard.instantiateInitialViewController() {
                        let nav: UINavigationController = self.getNavigationController(vc: vc, isTranslucent: isTranslucent)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        if withNav {
                            appDelegate.window?.rootViewController = nav
                        } else {
                            appDelegate.window?.rootViewController = vc
                        }
                        appDelegate.window?.makeKeyAndVisible()
                    }
             })
        } else {
            let storyboard = UIStoryboard(name: rootView.storyboardName, bundle: nil)
            if let vc = storyboard.instantiateInitialViewController() {
                let nav: UINavigationController = getNavigationController(vc: vc, isTranslucent: isTranslucent)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if withNav {
                    appDelegate.window?.rootViewController = nav
                } else {
                    appDelegate.window?.rootViewController = vc
                }
                appDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    private func getNavigationController(vc: UIViewController, isTranslucent: Bool = false, isFullScreen: Bool = false, to: NavigationOpeningSender = .home) -> UINavigationController {
        
        let nav: UINavigationController = UINavigationController(rootViewController: vc)
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            
            appearance.backgroundColor = to.navColor
            appearance.shadowColor = .clear
            appearance.shadowImage = UIImage()
            appearance.backgroundImage = UIImage()
            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.PrimaryBold(size: 18), NSAttributedString.Key.foregroundColor: UIColor.black]
            
            nav.navigationBar.scrollEdgeAppearance = appearance
            nav.navigationBar.standardAppearance = appearance
            nav.navigationBar.compactAppearance = appearance
        } else {
            
            nav.navigationBar.barTintColor = to.navColor
            nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.bottom, barMetrics: .default)
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.isTranslucent = true
            nav.navigationBar.isHidden = true
            nav.navigationBar.barStyle = .black
            nav.navigationBar.tintColor = .black
            nav.navigationBar.layoutIfNeeded()
        }

        return nav
    }
    
}
