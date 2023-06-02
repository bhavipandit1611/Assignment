//
//  AppDelegate.swift
//  Todolist
//
//  Created by Bhavi on 01/06/23.
//

import IQKeyboardManagerSwift
import UIKit
import MagicalRecord

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        database()
        setupUIAppearance()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate {
    func database() {
        MagicalRecord.setLoggingLevel(MagicalRecordLoggingLevel.off)
        MagicalRecord.setShouldDeleteStoreOnModelMismatch(true)
        MagicalRecord.setupCoreDataStack(withAutoMigratingSqliteStoreNamed: Config.db)

        Config.db_context = NSManagedObjectContext.mr_default()
        Config.db_memory_context = NSManagedObjectContext.mr_context(with: NSPersistentStoreCoordinator.mr_default()!)
    }

    func setupUIAppearance() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 75
        IQKeyboardManager.shared.toolbarTintColor = Asset.Colors.black.color

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, .font: AppFont.medium.size(18, family_Name: roboto)]

        // Set navigation bar item tint color
        UIBarButtonItem.appearance().tintColor = .black
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().isTranslucent = true
    }
}
