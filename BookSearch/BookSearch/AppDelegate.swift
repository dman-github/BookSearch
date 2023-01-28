//
//  AppDelegate.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 23/01/2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Intialisation of Coredata
        CoreDataStackMain.shared.intialise()
        return true
    }
}

