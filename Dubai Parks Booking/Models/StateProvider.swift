import Foundation
import SwiftUI
import UIKit

// Minimal StateProvider to make the app compile
class StateProvider: ObservableObject {
    static let shared = StateProvider()
    
    init() {}
    
    @Published var showOnboarding = false
    @Published var showPaywall = false
    @Published var isSubscribed = false
    @Published var isBlurred = false
    @Published var isLoading = false
    @Published var isSharing = false
    @Published var imageToShare: UIImage?
    @Published var stringToShare = ""
    @Published var path: [NavigationDestination] = []
    
    // Profile data
    @Published var profileImage: UIImage?
    @Published var profileNickname: String = ""
    
    // User stats
    @Published var parksVisited: Int = 0
    @Published var totalHoursSpent: Int = 0
    @Published var favoritePlaces: Int = 0
    @Published var reviewsGiven: Int = 0
    
    // Activity tracking
    @Published var visitedParks: Set<String> = []
    @Published var sessionStartTime: Date?
    @Published var totalSessionTime: TimeInterval = 0
    
    // Events
    @Published var events: [Event] = []
    @Published var likedEvents: Set<String> = []
    
    let haptics = UIImpactFeedbackGenerator(style: .medium)
    
    func loadContent() {
        // Load any saved state or content
        loadProfileData()
        loadEventsData()
        loadLikedEvents()
    }
    
    func saveProfileData() {
        UserDefaults.standard.set(profileNickname, forKey: "profileNickname")
        UserDefaults.standard.set(parksVisited, forKey: "parksVisited")
        UserDefaults.standard.set(totalHoursSpent, forKey: "totalHoursSpent")
        UserDefaults.standard.set(favoritePlaces, forKey: "favoritePlaces")
        UserDefaults.standard.set(reviewsGiven, forKey: "reviewsGiven")
        UserDefaults.standard.set(Array(visitedParks), forKey: "visitedParks")
        UserDefaults.standard.set(totalSessionTime, forKey: "totalSessionTime")
        
        if let image = profileImage,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(imageData, forKey: "profileImageData")
        }
        
        // Set install date if not already set
        if UserDefaults.standard.object(forKey: "installDate") == nil {
            UserDefaults.standard.set(Date(), forKey: "installDate")
        }
    }
    
    func loadProfileData() {
        profileNickname = UserDefaults.standard.string(forKey: "profileNickname") ?? ""
        parksVisited = UserDefaults.standard.integer(forKey: "parksVisited")
        totalHoursSpent = UserDefaults.standard.integer(forKey: "totalHoursSpent")
        favoritePlaces = UserDefaults.standard.integer(forKey: "favoritePlaces")
        reviewsGiven = UserDefaults.standard.integer(forKey: "reviewsGiven")
        
        // Set some default stats for demo if first time
        if parksVisited == 0 && totalHoursSpent == 0 && favoritePlaces == 0 && reviewsGiven == 0 {
            parksVisited = 3
            totalHoursSpent = 12
            favoritePlaces = 2
            reviewsGiven = 1
            saveProfileData()
        }
        
        if let imageData = UserDefaults.standard.data(forKey: "profileImageData"),
           let image = UIImage(data: imageData) {
            profileImage = image
        }
        
        // Load visited parks
        if let visitedParksArray = UserDefaults.standard.array(forKey: "visitedParks") as? [String] {
            visitedParks = Set(visitedParksArray)
        }
        
        // Load total session time
        totalSessionTime = UserDefaults.standard.double(forKey: "totalSessionTime")
        
        // Set install date if not already set
        if UserDefaults.standard.object(forKey: "installDate") == nil {
            UserDefaults.standard.set(Date(), forKey: "installDate")
        }
    }
    
    // MARK: - Activity Tracking Methods
    
    func trackParkVisit(_ parkName: String) {
        visitedParks.insert(parkName)
        parksVisited = visitedParks.count
        saveProfileData()
        print("🎯 Tracked visit to \(parkName). Total parks visited: \(parksVisited)")
    }
    
    func startSession() {
        sessionStartTime = Date()
        print("⏰ Session started at \(Date())")
    }
    
    func endSession() {
        guard let startTime = sessionStartTime else { return }
        let sessionDuration = Date().timeIntervalSince(startTime)
        totalSessionTime += sessionDuration
        totalHoursSpent = Int(totalSessionTime / 3600) // Convert to hours
        sessionStartTime = nil
        saveProfileData()
        print("⏰ Session ended. Duration: \(sessionDuration / 60) minutes. Total hours: \(totalHoursSpent)")
    }
    
    func addToFavorites(_ parkName: String) {
        favoritePlaces += 1
        saveProfileData()
        print("❤️ Added \(parkName) to favorites. Total favorites: \(favoritePlaces)")
    }
    
    func removeFromFavorites(_ parkName: String) {
        if favoritePlaces > 0 {
            favoritePlaces -= 1
            saveProfileData()
            print("💔 Removed \(parkName) from favorites. Total favorites: \(favoritePlaces)")
        }
    }
    
    func addReview() {
        reviewsGiven += 1
        saveProfileData()
        print("⭐ Review added. Total reviews: \(reviewsGiven)")
    }
    
    func resetStats() {
        visitedParks.removeAll()
        parksVisited = 0
        totalHoursSpent = 0
        favoritePlaces = 0
        reviewsGiven = 0
        totalSessionTime = 0
        likedEvents.removeAll()
        saveProfileData()
        saveLikedEvents()
        print("🔄 Stats reset")
    }
    
    // MARK: - Events Management
    
    func addEvent(_ event: Event) {
        events.append(event)
        saveEventsData()
        print("📅 Added event: \(event.title)")
    }
    
    func updateEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
            saveEventsData()
            print("📅 Updated event: \(event.title)")
        }
    }
    
    func deleteEvent(_ event: Event) {
        events.removeAll { $0.id == event.id }
        saveEventsData()
        print("📅 Deleted event: \(event.title)")
    }
    
    func saveEventsData() {
        do {
            let data = try JSONEncoder().encode(events)
            UserDefaults.standard.set(data, forKey: "userEvents")
        } catch {
            print("❌ Failed to save events: \(error)")
        }
    }
    
    func loadEventsData() {
        guard let data = UserDefaults.standard.data(forKey: "userEvents") else { return }
        do {
            events = try JSONDecoder().decode([Event].self, from: data)
            print("📅 Loaded \(events.count) events")
        } catch {
            print("❌ Failed to load events: \(error)")
        }
    }
    
    // MARK: - Liked Events Management
    
    func likeEvent(_ eventId: String) {
        likedEvents.insert(eventId)
        saveLikedEvents()
        print("❤️ Liked event: \(eventId)")
    }
    
    func unlikeEvent(_ eventId: String) {
        likedEvents.remove(eventId)
        saveLikedEvents()
        print("💔 Unliked event: \(eventId)")
    }
    
    func isEventLiked(_ eventId: String) -> Bool {
        return likedEvents.contains(eventId)
    }
    
    func saveLikedEvents() {
        UserDefaults.standard.set(Array(likedEvents), forKey: "likedEvents")
    }
    
    func loadLikedEvents() {
        if let likedArray = UserDefaults.standard.array(forKey: "likedEvents") as? [String] {
            likedEvents = Set(likedArray)
            print("❤️ Loaded \(likedEvents.count) liked events")
        }
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