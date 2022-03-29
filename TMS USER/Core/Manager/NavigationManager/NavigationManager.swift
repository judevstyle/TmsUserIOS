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
        default:
            return ""
        }
    }
    
    public var navColor: UIColor {
        switch self {
        case .splash:
            return .Primary
        default:
            return .clear
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
        case presentFullScreen(completion: (() -> Void)?)
        
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
        }
        self.currentPresentation = presentation
    }
    
    func pushViewController(vc: UIViewController, animated: Bool, to: NavigationOpeningSender) {
        let topVC = UIApplication.getTopViewController()
        if let nav = topVC?.navigationController {
            nav.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            nav.navigationBar.tintColor = .black
            nav.pushViewController(vc, animated: animated)
        } else {
            self.navigationController.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController.navigationBar.tintColor = .black
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
