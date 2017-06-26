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

import  OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Provide Google Maps Key
        GMSPlacesClient.provideAPIKey("AIzaSyAb6GwMWZr5zGVO7q9OqFbgDRhVXB9kEf0")
        GMSServices.provideAPIKey("AIzaSyAb6GwMWZr5zGVO7q9OqFbgDRhVXB9kEf0")
    
        // firebse configrartion
        FirebaseApp.configure()
        
        if let userLogined = defaults.value(forKey: "loginStatus") as? Bool {
            print("userlogined\(userLogined)")
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var navigationController = storyboard.instantiateViewController(withIdentifier: "matchDetailsNav") as! UINavigationController
            if !userLogined {
                navigationController = storyboard.instantiateViewController(withIdentifier: "siginVC") as! UINavigationController
            }
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace '11111111-2222-3333-4444-0123456789ab' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "181dcb38-b914-4abc-b81e-beb0df2f3523",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        // Sync hashed email if you have a login system or collect it.
        //   Will be used to reach the user at the most optimal time of day.
        // OneSignal.syncHashedEmail(userEmail)
        
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
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        print("Device token: \(deviceTokenString)")
        
    }
    
    
    
    

}

