//
//  AppDelegate.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/6/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UNUserNotificationCenterDelegate, MessagingDelegate{

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Provide Google Maps Key
        GMSPlacesClient.provideAPIKey("AIzaSyAb6GwMWZr5zGVO7q9OqFbgDRhVXB9kEf0")
        GMSServices.provideAPIKey("AIzaSyAb6GwMWZr5zGVO7q9OqFbgDRhVXB9kEf0")
    
        // FireBase Configration
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        
        if let userLogined = defaults.value(forKey: "loginStatus") as? Bool {
            print("userlogined\(userLogined)")
            if !userLogined {
                print("geet wala ay 7aga")

                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "siginVC") as! UINavigationController
                self.window?.rootViewController = navigationController
                self.window?.makeKeyAndVisible()
            }else {
                print("geet wala ay 7aga matchDetailsNav")

                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "matchDetailsNav") as! UINavigationController
                self.window?.rootViewController = navigationController
                self.window?.makeKeyAndVisible()
                
                
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationDidEnterBackground")
        RequestManager.defaultManager.updateUserAvailability(userStatus: .offline)
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("applicationDidBecomeActive")
        RequestManager.defaultManager.updateUserAvailability(userStatus: .online)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate")
        
    }
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
        print("gggtttttttttt")
    }
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
    print("fcmToken:\(fcmToken)")
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print(token)
        print("ffff")
    }

    

}

