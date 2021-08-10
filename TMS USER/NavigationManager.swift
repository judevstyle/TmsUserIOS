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
    
    //Main Tabbar
    case mainApp
    case home
    case order
    case history
    case profile
    
    //Cart
    case productCart
    
    //Modal
    case productDetailBottomSheet
    
    //OrderDetail
    case orderDetail
    
    //OrderTracking
    case orderTracking
    
    public var storyboardName: String {
        switch self {
        case .splash:
            return "Splash"
        case .intro:
            return "Intro"
        case .login:
            return "Login"
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
        case .productCart:
            return "ตะกร้าสินค้า"
        case .orderDetail:
            return "รายละเอียดการสั่งซื้อ"
        default:
            return ""
        }
    }
}

class NavigationManager {
    static let instance:NavigationManager = NavigationManager()
    
    var navigationController: UINavigationController!
    var currentPresentation: Presentation = .Root
    
    enum Presentation {
        case Root
        case Replace
        case Push
        case ModalNoNav(completion: (() -> Void)?)
        case ModelNav(completion: (() -> Void)?, isFullScreen: Bool)
        case BottomSheet(completion: (() -> Void)?, height: CGFloat)
        case PopupSheet(completion: (() -> Void)?)
        case presentFullSceen(completion: (() -> Void)?)
        
    }
    
    init() {
        
    }

    
    func setupWithNavigationController(navigationController: UINavigationController?) {
        if let nav = navigationController {
            self.navigationController = nav
        }
    }
    
    func pushVC(to: NavigationOpeningSender, presentation: Presentation = .Push, isHiddenNavigationBar: Bool = false) {
        let loadingStoryBoard = to.storyboardName
        
        let storyboard = UIStoryboard(name: loadingStoryBoard, bundle: nil)
        var viewController: UIViewController = UIViewController()
        
        switch to {
        default:
            viewController = storyboard.instantiateInitialViewController() ?? to.viewController
        }
        
        viewController.navigationItem.title = to.titleNavigation
        
        viewController.hideKeyboardWhenTappedAround()
        
        self.presentVC(viewController: viewController, presentation: presentation, isHiddenNavigationBar: isHiddenNavigationBar, to: to)
    }
    
    private func presentVC(viewController: UIViewController, presentation: Presentation, isHiddenNavigationBar: Bool = false, to: NavigationOpeningSender) {
        if let nav = self.navigationController {
            nav.isNavigationBarHidden = isHiddenNavigationBar
        }
        switch presentation {
        case .Push:
            if (self.navigationController.tabBarController != nil) {
                viewController.hidesBottomBarWhenPushed = true
            }
            
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController.pushViewController(viewController, animated: true)
            
        case .Root:
            let storyboard = UIStoryboard(name: to.storyboardName, bundle: nil)
            let initialViewController = storyboard.instantiateInitialViewController()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        case .ModalNoNav(let completion):
            let nav: UINavigationController = getNavigationController(vc: viewController, isTranslucent: true)
            self.navigationController.present(nav, animated: true, completion: completion)
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
        case .presentFullSceen(let completion):
            
            let nav: UINavigationController = UINavigationController(rootViewController: viewController)
            nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.isTranslucent = true
            
            nav.view.backgroundColor = UIColor.black
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            
            self.navigationController.present(nav, animated: true, completion: completion)
        }
        self.currentPresentation = presentation
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
    
    private func getNavigationController(vc: UIViewController, isTranslucent: Bool, isFullScreen: Bool = false) -> UINavigationController {
        let nav: UINavigationController = UINavigationController(rootViewController: vc)
        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isTranslucent = isTranslucent == true ? true : false
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.PrimaryMedium(size: 18), NSAttributedString.Key.foregroundColor: UIColor.white]
        nav.navigationBar.barTintColor = UIColor.Primary
        
        if isFullScreen == true {
            nav.modalPresentationStyle = .overFullScreen
        }
        return nav
    }
    
}
