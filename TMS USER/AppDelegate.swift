//
//  AppDelegate.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/9/21.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import RealmSwift
import Realm

//@main
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let shareDelegate = AppDelegate()
    var userProfile: CustomerItems? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        GMSServices.provideAPIKey("AIzaSyAXqmq0UGiG6YUx0rNAHNv8dXJ8jXs4Fbk")
        GMSPlacesClient.provideAPIKey("AIzaSyAXqmq0UGiG6YUx0rNAHNv8dXJ8jXs4Fbk")
        
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                }
        })

        Realm.Configuration.defaultConfiguration = config
        
        let loadingStoryBoard = "Splash"
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: loadingStoryBoard, bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: - SocketIOManager
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        SocketHelper.shared.closeConnection()
    }
    

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        SocketHelper.shared.establishConnection()
    }

}

