import SwiftUI
import FacebookCore

struct FacebookDebugView: View {
    @State private var eventLogs: [String] = []
    @State private var testEventName = "test_event"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Facebook SDK Debug")
                .font(.largeTitle)
                .padding()
            
            // SDK Info Section
            VStack(alignment: .leading, spacing: 10) {
                Text("SDK Information")
                    .font(.headline)
                
                Group {
                    Text("SDK Version: \(Settings.shared.sdkVersion)")
                    Text("App ID: \(Settings.shared.appID ?? "Not Set")")
                    Text("Client Token: \(Settings.shared.clientToken != nil ? "✅ Set" : "❌ Not Set")")
                    Text("Auto Log Events: \(Settings.shared.isAutoLogAppEventsEnabled ? "✅" : "❌")")
                    Text("Ad ID Collection: \(Settings.shared.isAdvertiserIDCollectionEnabled ? "✅" : "❌")")
                }
                .font(.system(.body, design: .monospaced))
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // Test Events Section
            VStack(spacing: 15) {
                Text("Test Events")
                    .font(.headline)
                
                Button("Send Test Install Event") {
                    sendTestInstallEvent()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Send Custom Test Event") {
                    sendCustomTestEvent()
                }
                .buttonStyle(.bordered)
                
                Button("Clear First Launch Flag") {
                    clearFirstLaunchFlag()
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
            
            // Event Logs
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Event Logs")
                        .font(.headline)
                    
                    ForEach(eventLogs, id: \.self) { log in
                        Text(log)
                            .font(.system(.caption, design: .monospaced))
                            .padding(5)
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(5)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .onAppear {
            logEvent("Debug view opened")
        }
    }
    
    private func sendTestInstallEvent() {
        AppEvents.shared.logEvent(.init("fb_mobile_first_app_launch"))
        logEvent("✅ Sent: fb_mobile_first_app_launch")
        
        let parameters: [AppEvents.ParameterName: Any] = [
            .init("test_mode"): true,
            .init("timestamp"): Date().timeIntervalSince1970,
            .init("device"): UIDevice.current.model
        ]
        AppEvents.shared.logEvent(.init("test_install"), parameters: parameters)
        logEvent("✅ Sent: test_install with parameters")
        
        AppEvents.shared.flush()
        logEvent("✅ Events flushed")
    }
    
    private func sendCustomTestEvent() {
        let eventName = "debug_test_\(Int.random(in: 1000...9999))"
        AppEvents.shared.logEvent(.init(eventName))
        logEvent("✅ Sent: \(eventName)")
        
        AppEvents.shared.flush()
    }
    
    private func clearFirstLaunchFlag() {
        UserDefaults.standard.removeObject(forKey: "HasLaunchedBefore")
        UserDefaults.standard.removeObject(forKey: "AppLaunchCount")
        logEvent("🔄 Cleared first launch flags - app will track as new install on next launch")
    }
    
    private func logEvent(_ message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        eventLogs.append("[\(timestamp)] \(message)")
    }
}

#Preview {
    FacebookDebugView()
}