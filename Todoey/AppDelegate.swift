//
//  AppDelegate.swift
//  Todoey
//
//  Created by DP on 10/05/18.
//  Copyright © 2018 nimitha. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     
        print(Realm.Configuration.defaultConfiguration.fileURL)
    
        return true
    }

     
   
}

