
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import Crashlytics
import Fabric

import UserNotifications
import FirebaseMessaging

let wizardKey = "5b11a333a3fc27f22c8b45fb"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        //Fabric.sharedSDK().debug = true
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
//
        
        setUpPushNotification()
        
        checkIfLoggedIn()
        
        return true
    }
    
    func checkIfLoggedIn(){
        
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
                if let _ = Auth.auth().currentUser{
        
                    window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "InstagramTabBarController") as? InstagramTabBarController
                }
                else{
                    window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "loginNavigationControllet")
                }
        
            }
    
    
    func setUpPushNotification(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self as? UNUserNotificationCenterDelegate
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (res, error) in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        
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
    }
    /*@available(iOS 9.0, *)
     func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
     let googleHandler = GIDSignIn.sharedInstance().handle(url,
     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
     
     return googleHandler
     }*/
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let googlehandler = GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,annotation: [:])
        
//        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[.sourceApplication] as! String, annotation: [:])
//
        return googlehandler
//        ||facebookDidHandle

    }
    
    
    //  AppDelegate.m
    
    /*- (BOOL)application:(UIApplication *)application
     didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     
     [[FBSDKApplicationDelegate sharedInstance] application:application
     didFinishLaunchingWithOptions:launchOptions];
     // Add any custom logic here.
     return YES;
     }
     
     - (BOOL)application:(UIApplication *)application
     openURL:(NSURL *)url
     options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
     
     BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
     openURL:url
     sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
     annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
     ];
     // Add any custom logic here.
     return handled;
     }*/
    
    
    
}
extension AppDelegate: MessagingDelegate{
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let varAvgvalue = String(format: "%@", deviceToken as CVarArg)
        
        let  token = varAvgvalue.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: "")
        
        Messaging.messaging().apnsToken = deviceToken
        print(token)
        // PushWizard.start(withToken: deviceToken, andAppKey: wizardKey, andValues: nil)
        //6da681660074d73bf94022b68ac37a9f869146eceaf45add410847b40d88c2fa
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        navToChat(with: userInfo)
        //userInfo["gcm.notification.sender"]
        //        guard let userInfo = userInfo as? [String : Any],
        //            let senderId = userInfo["gcm.notification.sender"] as? String,
        //            let root = window?.rootViewController as? UITabBarController,
        //            let chatNav = root.viewControllers?[3] as? UINavigationController,
        /*
         let chatVC = chatNav.visibleViewController as? ChatViewController,
         chatVC.receiver.id == senderId else {
         
         completionHandler(
         [UNNotificationPresentationOptions.alert,
         UNNotificationPresentationOptions.sound,
         UNNotificationPresentationOptions.badge])
         
         return*/
        //}
    
        
        // PushWizard.handleNotification(userInfo, processOnlyStatisticalData: false)
    }

    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage){
        if let userInfo = remoteMessage.appData as? [AnyHashable : Any]
        {
            print(userInfo)
            // navToChat(with: userInfo)
        }
    }
    
    func navToChat(with userInfo: [AnyHashable : Any]) {
        // Getting user info
        print(userInfo)
        let chatStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let senderId = userInfo["gcm.notification.sender"] as? String,
            let targetVC = chatStoryboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC,
            let root = window?.rootViewController as? UITabBarController,
            let chatNav = root.viewControllers?[1] as? UINavigationController,
            let friendsVC = (root.viewControllers?[2] as? UINavigationController)?.contains as? FollowingViewController,
            !(chatNav.visibleViewController is ChatVC) {

            var receiver: User!
            for friend in friendsVC.userFollowArr {
                if friend.UserID == senderId {
                    receiver = friend
                }
            }

            if receiver == nil {

                receiver = User(EmailID: "", UserID: senderId, FullName: "", PhoneNo: "", UserImage: "", posts: [], Following: [])
            }

            targetVC.friendObj = receiver
            chatNav.pushViewController(targetVC, animated: true)
            root.selectedIndex = 1
        }
    

    }

    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
        ///861381f97e792fb7281c248cebc998890aea36d64070e403bfef5c376965afde
        //dawVmt2z4Bs:APA91bGWwX0deKSTPrbQgN5FWSFNv72Q_Bkbdf24FpZBflLFvwZxZ8FVfm8ow--JUUrQgZGIeOAsoeMPLDbRh0KEvbMPshBIbwBY5wIMIiGL5iHiNaKMOxQc36cmgE-Aj89MshAotiDt
    }
}


