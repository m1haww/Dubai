import AdSupport
import AppTrackingTransparency
import AppsFlyerLib
import FacebookCore




import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate, AppsFlyerLibDelegate {
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
        if let status = conversionInfo["af_status"] as? String {
            if status == "Non-organic" {
                let mediaSource = conversionInfo["media_source"] as? String ?? "Unknown"
                let campaign = conversionInfo["campaign"] as? String ?? "Unknown"
                print("Non-organic install. Media source: \(mediaSource), Campaign: \(campaign)")
            } else if status == "Organic" {
                print("Organic install")
            }
        }
        
        print("Conversion Data: \(conversionInfo)")
    }
    
    func onConversionDataFail(_ error: any Error) {
        print("Error getting conversion data: \(error.localizedDescription)")
    }
    
    private func configureAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(Colors.shared.backgroundColor)
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(.white)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(.white)
        ]
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        let navigationBarStyle = UINavigationBarAppearance()
        
        navigationBarStyle.backgroundColor = UIColor(Colors.shared.backgroundColor)
        navigationBarStyle.shadowColor = nil
        
        UINavigationBar.appearance().standardAppearance = navigationBarStyle
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarStyle
        UINavigationBar.appearance().compactAppearance = navigationBarStyle
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        //        FirebaseApp.configure()
        //
        //        Purchases.logLevel = .info
        //        Purchases.configure(withAPIKey: Consts.shared.revenueCatApiKey)
        //
//        UNUserNotificationCenter.current().delegate = self
        
        initializeAppsFlyer()
        
        // Initialize Facebook SDK
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        // Configure Facebook SDK settings
        Settings.shared.isAutoLogAppEventsEnabled = true
        Settings.shared.isAdvertiserIDCollectionEnabled = true
        
        // Enable debug logging for Facebook SDK
        Settings.shared.loggingBehaviors = [.appEvents, .networkRequests, .developerErrors]
        
        // Log app activation for install tracking
        AppEvents.shared.activateApp()
        
        // Verify Facebook SDK initialization
        verifyFacebookSDK()
        
        // Track first launch/install
        trackAppInstall()
        
        Task {
//            await handleNotificationPermissions(application: application)
        }
        
        //        StateProvider.shared.loadContent()
        
        configureAppearance()
        
        return true
    }
    
    @MainActor
    private func requestATTPermission() async {
        guard #available(iOS 14, *) else { return }
        
        let status = await ATTrackingManager.requestTrackingAuthorization()
        switch status {
        case .authorized:
            print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
        case .denied:
            print("ATT permission denied during onboarding")
        case .restricted:
            print("ATT permission restricted during onboarding")
        case .notDetermined:
            print("ATT permission still not determined")
        @unknown default:
            print("Unknown ATT status")
        }
    }
    
    private func initializeAppsFlyer() {
        AppsFlyerLib.shared().appsFlyerDevKey = "rJMksbcBp2gp7wGG4PtGuU"
        AppsFlyerLib.shared().appleAppID = "6747714061"
        
        AppsFlyerLib.shared().isDebug = true
        
        AppsFlyerLib.shared().delegate = self
        
        AppsFlyerLib.shared().addPushNotificationDeepLinkPath(["af_push_link"])
        
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)

        NotificationCenter.default.addObserver(
            self, selector: #selector(sendLaunch), name: UIApplication.didBecomeActiveNotification,
            object: nil)
    }
    
    @objc private func sendLaunch() {
        AppsFlyerLib.shared().start()
        
        Task { @MainActor in
            await requestATTPermission()
        }
    }
    
    private func verifyFacebookSDK() {
        print("=== Facebook SDK Verification ===")
        print("SDK Version: \(Settings.shared.sdkVersion)")
        print("App ID: \(Settings.shared.appID ?? "Not Set")")
        print("Client Token Set: \(Settings.shared.clientToken != nil)")
        print("Auto Log App Events: \(Settings.shared.isAutoLogAppEventsEnabled)")
        print("Advertiser ID Collection: \(Settings.shared.isAdvertiserIDCollectionEnabled)")
        print("Data Processing Restricted: \(Settings.shared.isDataProcessingRestricted)")
        print("================================")
        
        // Test event to verify SDK is working
        AppEvents.shared.logEvent(AppEvents.Name("fb_sdk_verification_test"))
        print("✅ Test event sent: fb_sdk_verification_test")
    }
    
    private func trackAppInstall() {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "HasLaunchedBefore")
        
        print("=== Facebook Install Tracking ===")
        print("Is First Launch: \(isFirstLaunch)")
        
        if isFirstLaunch {
            // Track app install event
            AppEvents.shared.logEvent(AppEvents.Name("fb_mobile_first_app_launch"))
            print("✅ Event logged: fb_mobile_first_app_launch")
            
            // Log custom install event with additional parameters
            let parameters: [AppEvents.ParameterName: Any] = [
                AppEvents.ParameterName("install_source"): "organic",
                AppEvents.ParameterName("app_version"): Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown",
                AppEvents.ParameterName("device_model"): UIDevice.current.model,
                AppEvents.ParameterName("ios_version"): UIDevice.current.systemVersion
            ]
            AppEvents.shared.logEvent(AppEvents.Name("app_install"), parameters: parameters)
            print("✅ Event logged: app_install with parameters: \(parameters)")
            
            // Mark that the app has been launched
            UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
            
            print("✅ First launch tracked successfully")
        }
        
        // Log app launch count
        var launchCount = UserDefaults.standard.integer(forKey: "AppLaunchCount")
        launchCount += 1
        UserDefaults.standard.set(launchCount, forKey: "AppLaunchCount")
        
        // Log launch event with count
        AppEvents.shared.logEvent(AppEvents.Name("app_launch"), parameters: [AppEvents.ParameterName("launch_count"): launchCount])
        print("✅ Event logged: app_launch (count: \(launchCount))")
        print("================================")
        
        // Flush events immediately for testing
        AppEvents.shared.flush()
        print("✅ Events flushed to Facebook")
    }
    
    //    @MainActor
    //    private func handleNotificationPermissions(application: UIApplication) async {
    //        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    //        do {
    //            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
    //                options: authOptions)
    //            print("Notification authorization granted: \(granted)")
    //        } catch {
    //            print("Notification authorization error: \(error.localizedDescription)")
    //        }
    //
    //        application.registerForRemoteNotifications()
    //
    //        Messaging.messaging().delegate = self
    //    }
    
    func application(
        _ application: UIApplication, continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        return true
    }
    
    func application(
        _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        // Handle Facebook SDK URLs
        let handled = ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        // Handle AppsFlyer URLs
        AppsFlyerLib.shared().handleOpen(url, options: options)
        
        return handled
    }
}

@main
struct Dubai_Parks_BookingApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            let _ = print("🚨 MAIN APP: Creating ContentView in WindowGroup")
            ContentView()
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                    case .active:
                        StateProvider.shared.startSession()
                    case .inactive, .background:
                        StateProvider.shared.endSession()
                    @unknown default:
                        break
                    }
                }
                .onOpenURL { url in
                    // Handle Facebook SDK URLs for scene-based apps
                    ApplicationDelegate.shared.application(
                        UIApplication.shared,
                        open: url,
                        sourceApplication: nil,
                        annotation: [UIApplication.OpenURLOptionsKey.annotation]
                    )
                }
        }
    }
}

//
    //extension AppDelegate: UNUserNotificationCenterDelegate {
    //    func userNotificationCenter(
    //        _ center: UNUserNotificationCenter,
    //        willPresent notification: UNNotification
    //    ) async
    //    -> UNNotificationPresentationOptions
    //    {
    //        return [[.badge, .sound]]
    //    }
    //
    //    func userNotificationCenter(
    //        _ center: UNUserNotificationCenter,
    //        didReceive response: UNNotificationResponse
    //    ) async {
    //        let userInfo = response.notification.request.content.userInfo
    //
    //        print("Notification tapped with userInfo: \(userInfo)")
    //
    //        AppsFlyerLib.shared().handlePushNotification(userInfo)
    //    }
    //}
    //
    //extension AppDelegate: MessagingDelegate {
    //    func application(
    //        _ application: UIApplication,
    //        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    //    ) {
    //        Messaging.messaging().apnsToken = deviceToken
    //    }
    //
    //    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    //        guard let fcmToken = fcmToken else {
    //            print("No FCM token received")
    //            return
    //        }
    //
    //        print("FCM Token: \(fcmToken)")
    //        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
    //
    //        let dataDict: [String: String] = ["token": fcmToken]
    //
    //        NotificationCenter.default.post(
    //            name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    //    }
    //}
