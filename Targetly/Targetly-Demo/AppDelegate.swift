//
//  AppDelegate.swift
//  Targetly-Demo
//
//  Created by Targetly on 19/07/2021.
//  Copyright © 2021 Targetly. All rights reserved.
//

import UIKit
import Targetly

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerForPushNotifications()

        // Initialize Targetly
        Targetly.initialize(accessToken: "4001acd468d02c5f4deb33e97e3c105e")

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Targetly.setDeviceToken(deviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {        
    }
    
    /// Get notifications settings
    func getNotificationSettings(withRegister: Bool) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else {
                return
            }
            // register for remote notificaitons
            if withRegister {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    /// Register for remote notifications
    func registerForPushNotifications() {
        // register for notifications
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
            guard granted else {
                return
            }
            // get notificaiton settings and check for any changes
            self.getNotificationSettings(withRegister: true)
        }
    }
    
    /// Unregister for push notifications
    func unregisterForPushNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
}
