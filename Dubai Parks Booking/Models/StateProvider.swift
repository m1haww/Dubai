import Foundation
import SwiftUI
import UIKit

// Minimal StateProvider to make the app compile
class StateProvider: ObservableObject {
    static let shared = StateProvider()
    
    @Published var showOnboarding = false
    @Published var showPaywall = false
    @Published var isSubscribed = false
    @Published var isBlurred = false
    @Published var isLoading = false
    @Published var isSharing = false
    @Published var imageToShare: UIImage?
    @Published var stringToShare = ""
    @Published var path: [NavigationDestination] = []
    
    let haptics = UIImpactFeedbackGenerator(style: .medium)
    
    func loadContent() {
        // Load any saved state or content
    }
}

// Navigation destinations enum
enum NavigationDestination: Hashable {
    case settingsView
    case chatView(prompt: String, modelType: String, chatHistory: [String])
    case summaryView(text: String, isLyrics: Bool)
    case imageDataView(image: UIImage)
    case audioDataView(audioData: Data)
}