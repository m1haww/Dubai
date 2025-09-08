import SwiftUI
import AppsFlyerLib
import FBSDKCoreKit
//import FirebaseAnalytics


struct ContentView: View {
    @State private var hasCompletedOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    @State private var showAquarium: Bool = false
    
    init() {
        print("🏁 ContentView INIT - Starting app")
    }
    
    var body: some View {
        if showAquarium {
            WebViewScreen(url: "https://dubaiparks.click/1", parkName: "Dubai Aquarium", isFromOnboarding: true)
                .onAppear {
                    NotificationCenter.default.addObserver(
                        forName: Notification.Name("DismissWebView"),
                        object: nil,
                        queue: .main
                    ) { _ in
                        showAquarium = false
                    }
                }
        } else if hasCompletedOnboarding {
            ParksView()
        } else {
            OnboardingView(onboardingCompleted: {
                UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                hasCompletedOnboarding = true
                showAquarium = true
            })
        }
    }
}
