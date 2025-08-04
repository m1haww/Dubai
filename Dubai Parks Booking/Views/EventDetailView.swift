import SwiftUI

struct EventDetailView: View {
    let event: Event
    @StateObject private var stateProvider = StateProvider.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var showDeleteAlert = false
    @State private var showEditView = false
    @State private var showReviewAlert = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.leading)
                    
                    Text("Event Details")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                    
                    Spacer()
                    
                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing)
                }
                .frame(height: 60)
                .background(Color(hex: "703CF1"))
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Event Image
                        if let image = event.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipped()
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 200)
                                .overlay(
                                    VStack(spacing: 8) {
                                        Image(systemName: "photo")
                                            .font(.system(size: 40))
                                            .foregroundColor(.gray)
                                        
                                        Text("No Image")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            // Title
                            Text(event.title)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color(hex: "454545"))
                                .padding(.top, 16)
                            
                            // Date and Time
                            HStack(spacing: 12) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(hex: "703CF1"))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Date & Time")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    Text(formatFullDate(event.date))
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color(hex: "454545"))
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.05))
                            )
                            
                            // Location
                            HStack(spacing: 12) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(hex: "703CF1"))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Location")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    Text(event.location)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color(hex: "454545"))
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.05))
                            )
                            
                            // Description
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Description")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color(hex: "454545"))
                                
                                Text(event.description)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "454545"))
                                    .lineSpacing(2)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.05))
                            )
                            
                            // Action Buttons
                            VStack(spacing: 10) {
                                Button(action: {
                                    shareEvent()
                                }) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                        
                                        Text("Share Event")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color(hex: "703CF1"))
                                    .cornerRadius(8)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                HStack(spacing: 8) {
                                    // Like Button
                                    Button(action: {
                                        let eventIdString = event.id.uuidString
                                        if stateProvider.isEventLiked(eventIdString) {
                                            stateProvider.unlikeEvent(eventIdString)
                                            stateProvider.removeFromFavorites(event.title)
                                        } else {
                                            stateProvider.likeEvent(eventIdString)
                                            stateProvider.addToFavorites(event.title)
                                        }
                                    }) {
                                        let isLiked = stateProvider.isEventLiked(event.id.uuidString)
                                        HStack {
                                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                                .font(.system(size: 16))
                                                .foregroundColor(isLiked ? .white : Color(hex: "703CF1"))
                                            
                                            Text(isLiked ? "Liked" : "Like")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(isLiked ? .white : Color(hex: "703CF1"))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(isLiked ? Color(hex: "703CF1") : Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(hex: "703CF1"), lineWidth: 2)
                                        )
                                        .cornerRadius(8)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    // Review Button
                                    Button(action: {
                                        showReviewAlert = true
                                    }) {
                                        HStack {
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(Color(hex: "703CF1"))
                                            
                                            Text("Review")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(Color(hex: "703CF1"))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(hex: "703CF1"), lineWidth: 2)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.top, 8)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20) // Add bottom padding for safe area
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Delete Event", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                stateProvider.deleteEvent(event)
                presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this event?")
        }
        .alert("Leave a Review", isPresented: $showReviewAlert) {
            Button("Leave Review") {
                stateProvider.addReview()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("How was your experience with \(event.title)?")
        }
    }
    
    private func formatFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func shareEvent() {
        let shareText = """
        📅 \(event.title)
        
        📍 \(event.location)
        🗓️ \(formatFullDate(event.date))
        
        \(event.description)
        """
        
        let activityViewController = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        // For iPad support
        activityViewController.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
        activityViewController.popoverPresentationController?.permittedArrowDirections = []
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            rootViewController.present(activityViewController, animated: true)
        }
    }
    
}