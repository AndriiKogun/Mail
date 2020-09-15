//
//  AppDelegate.swift
//  Mail
//
//  Created by A K on 10/31/19.
//  Copyright © 2019 AK. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        let vc: UIViewController!
//        
//        if DataManager.shared.user() != nil {
//            vc = UINavigationController(rootViewController: MailsListViewController())
//        } else {
//            vc = LoginViewController()
//        }
        
        FirebaseApp.configure()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["97535C56-B88E-4472-9504-4"]

        #if RELEASE
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        #else
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
        #endif

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = UIViewController()
//        SessionManager.shared.getStarted()

        let mainViewController = MailsListViewController()
        let leftViewController = LeftMenuViewController()

        let sideMenuViewController = SideMenuViewController(rootViewController: mainViewController,
                                                            leftViewController: leftViewController,
                                                            rightViewController: nil)
        
        let navigationController = UINavigationController(rootViewController: sideMenuViewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.backgroundColor = UIColor.white
        
        
        window?.rootViewController = navigationController
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

