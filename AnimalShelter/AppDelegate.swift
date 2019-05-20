//
//  AppDelegate.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 4/18/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import UIKit
import Firebase
import Firebase
import UserNotifications
import UserNotificationsUI
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Auth.auth().addStateDidChangeListener {(auth, user) in
            if user == nil {
                self.showModalAuth()
            }
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]){(auth:Bool, error:Error?) in
            if !auth{
                
            }
        }
        
        let ok = UNNotificationAction(identifier: "ok", title: "ok", options:[])
        let cancel = UNNotificationAction(identifier: "cancel", title: "cancel", options:[])
        
        let category = UNNotificationCategory(identifier: "actionCategory", actions: [ok, cancel], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        
        return true
    }
    
    func scheduleNotication(){
        UNUserNotificationCenter.current().delegate = self
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Make a call"
        content.body = "remind you to make call to adopt pet"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "actionCategory"
        
        guard let path = Bundle.main.path(forResource: "sadCat", ofType: ".jpeg") else {return}
        let url = URL(fileURLWithPath: path)
        do {
            let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
            content.attachments = [attachment]
        } catch{
            print ("The attachement could`not be loaded")
        }
        
        let request = UNNotificationRequest(identifier: "remindNotification", content: content, trigger: triger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    func showModalAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newc = storyboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        self.window?.rootViewController?.present(newc, animated: false, completion: nil)
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        PersistentService.saveContext()
    }
    
   

}

