//
//  AppDelegate.swift
//  weatherApp
//
//  Created by Slava Korolevich on 9/17/20.
//  Copyright © 2020 Slava Korolevich. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: TabBarController())
        window?.makeKeyAndVisible()
        return true
    }

}

