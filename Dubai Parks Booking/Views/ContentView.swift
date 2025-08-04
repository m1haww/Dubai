import SwiftUI
import AppsFlyerLib
import FBSDKCoreKit
//import FirebaseAnalytics


struct ContentView: View {
    init() {
        print("🏁 ContentView INIT - Starting app")
    }
    
    var body: some View {
        print("🎯 ContentView body - About to show ParksView")
        return ParksView()
    }
}
