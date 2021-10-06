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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey("AIzaSyDg-bwviwDVeAhD_JPJt4mdCidS9dK4uvA")
        GMSPlacesClient.provideAPIKey("AIzaSyDg-bwviwDVeAhD_JPJt4mdCidS9dK4uvA")
        
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

