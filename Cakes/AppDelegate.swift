//
//  AppDelegate.swift
//  Cakes
//
//  Created by Mikhail Seregin on 31.03.17.
//  Copyright © 2017 Mikhail Seregin. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

  var window: UIWindow?

  @available(iOS 9.0, *)
  func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
    -> Bool {
      return self.application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: "")
  }
  
  func application(_ application: UIApplication,
                   open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    FIRApp.configure()
    GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
    GIDSignIn.sharedInstance().delegate = self
    
    if #available(iOS 10.0, *) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions) {_,_ in }
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
    } else {
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
    }
    application.registerForRemoteNotifications()
    UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
    UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    UITabBar.appearance().tintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
    UITabBar.appearance().backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    return true
  }
    
  
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
    if let error = error {
      print("Error \(error)")
      return
    }
    guard let authentication = user.authentication else {return}
    let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
    
    FIRAuth.auth()?.signIn(with: credential) {(user, error) in
      if let error = error {
        print("Error: \(error)")
        return
      }
    }
    
  }
  

  func applicationWillResignActive(_ application: UIApplication) {
    
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    
  }

  func applicationWillTerminate(_ application: UIApplication) {
    
  }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        showAlert(withUserInfo: userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        showAlert(withUserInfo: userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func showAlert(withUserInfo userInfo: [AnyHashable : Any]) {
        let apsKey = "aps"
        let gcmMessage = "alert"
        let gcmLabel = "google.c.a.c_l"
        
        if let aps = userInfo[apsKey] as? NSDictionary {
            if let message = aps[gcmMessage] as? String {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: userInfo[gcmLabel] as? String ?? "",
                                                  message: message, preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
                    alert.addAction(dismissAction)
                    self.window?.rootViewController?.presentedViewController?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
import UserNotifications

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        showAlert(withUserInfo: userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        showAlert(withUserInfo: userInfo)
        
        completionHandler()
    }
}


