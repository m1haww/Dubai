import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var stateProvider = StateProvider.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var showingImagePicker = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var isEditing = false
    @State private var tempNickname = ""
    @State private var showResetAlert = false
    @State private var showToast = false
    @State private var toastMessage = ""
    
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
                    
                    Text("Profile")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                    
                    Spacer()
                    
                    Button(action: {
                        if isEditing {
                            stateProvider.profileNickname = tempNickname
                            stateProvider.saveProfileData()
                        } else {
                            tempNickname = stateProvider.profileNickname
                        }
                        isEditing.toggle()
                    }) {
                        Text(isEditing ? "Save" : "Edit")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing)
                }
                .frame(height: 60)
                .background(Color(hex: "703CF1"))
                
                // Profile Content
                ScrollView {
                    VStack(spacing: 30) {
                        // Profile Image Section
                        VStack(spacing: 20) {
                            Button(action: {
                                showingImagePicker = true
                            }) {
                                ZStack {
                                    if let profileImage = stateProvider.profileImage {
                                        Image(uiImage: profileImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 120, height: 120)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(Color(hex: "703CF1"), lineWidth: 4)
                                            )
                                    } else {
                                        Circle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 120, height: 120)
                                            .overlay(
                                                Image(systemName: "person.fill")
                                                    .font(.system(size: 50))
                                                    .foregroundColor(.gray)
                                            )
                                            .overlay(
                                                Circle()
                                                    .stroke(Color(hex: "703CF1"), lineWidth: 4)
                                            )
                                    }
                                    
                                    // Camera icon overlay
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Circle()
                                                .fill(Color(hex: "703CF1"))
                                                .frame(width: 36, height: 36)
                                                .overlay(
                                                    Image(systemName: "camera.fill")
                                                        .font(.system(size: 16))
                                                        .foregroundColor(.white)
                                                )
                                                .offset(x: -8, y: -8)
                                        }
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Text("Tap to change photo")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 30)
                        
                        // Profile Info Section
                        VStack(spacing: 25) {
                            // Nickname Section
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Nickname")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color(hex: "454545"))
                                    Spacer()
                                }
                                
                                if isEditing {
                                    TextField("Enter your nickname", text: $tempNickname)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .font(.system(size: 16))
                                } else {
                                    HStack {
                                        Text(stateProvider.profileNickname.isEmpty ? "Add a nickname" : stateProvider.profileNickname)
                                            .font(.system(size: 16))
                                            .foregroundColor(stateProvider.profileNickname.isEmpty ? .gray : Color(hex: "454545"))
                                        Spacer()
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.1))
                                    )
                                }
                            }
                            
                            // User Stats Section
                            VStack(spacing: 15) {
                                HStack {
                                    Text("Your Activity")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(Color(hex: "454545"))
                                    Spacer()
                                }
                                
                                HStack(spacing: 15) {
                                    StatCard(
                                        icon: "ticket.fill",
                                        title: "Parks Visited",
                                        value: "\(stateProvider.parksVisited)",
                                        color: Color(hex: "703CF1")
                                    )
                                    
                                    StatCard(
                                        icon: "clock.fill",
                                        title: "Hours Spent",
                                        value: "\(stateProvider.totalHoursSpent)",
                                        color: Color.orange
                                    )
                                }
                                
                                HStack(spacing: 15) {
                                    StatCard(
                                        icon: "heart.fill",
                                        title: "Favorites",
                                        value: "\(stateProvider.favoritePlaces)",
                                        color: Color.red
                                    )
                                    
                                    StatCard(
                                        icon: "star.fill",
                                        title: "Reviews",
                                        value: "\(stateProvider.reviewsGiven)",
                                        color: Color.yellow
                                    )
                                }
                                
                                HStack(spacing: 15) {
                                    StatCard(
                                        icon: "calendar.badge.plus",
                                        title: "Events Created",
                                        value: "\(stateProvider.events.count)",
                                        color: Color.green
                                    )
                                    
                                    // Add a placeholder or another stat here if needed
                                    StatCard(
                                        icon: "eye.fill",
                                        title: "Total Likes",
                                        value: "\(stateProvider.likedEvents.count)",
                                        color: Color.pink
                                    )
                                }
                            }
                            
                            // My Events Section
                            if !stateProvider.events.isEmpty {
                                VStack(spacing: 15) {
                                    HStack {
                                        Text("My Events")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(Color(hex: "454545"))
                                        Spacer()
                                        
                                        NavigationLink(destination: EventsView()) {
                                            Text("View All")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(Color(hex: "703CF1"))
                                        }
                                    }
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(stateProvider.events.prefix(3)) { event in
                                                NavigationLink(destination: EventDetailView(event: event)) {
                                                    ProfileEventCard(event: event)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                        .padding(.horizontal, 2)
                                    }
                                }
                            }
                            
                            // App Info Section
                            VStack(spacing: 15) {
                                HStack {
                                    Text("App Information")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(Color(hex: "454545"))
                                    Spacer()
                                }
                                
                             
                                
                                
                              
                            }
                         
                        }
                        .padding(.horizontal, 20)
                        
                        // Actions Section
                        VStack(spacing: 15) {
                            Button(action: {
                                shareApp()
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color(hex: "703CF1"))
                                    
                                    Text("Share")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color(hex: "454545"))
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                showResetAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: 18))
                                        .foregroundColor(.red)
                                    
                                    Text("Reset Stats")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color(hex: "454545"))
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 50)
                    }
                }
            }
            
            // Toast notification overlay
            if showToast {
                VStack {
                    Spacer()
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                        
                        Text(toastMessage)
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.8))
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity
                    ))
                    .animation(.easeInOut(duration: 0.3), value: showToast)
                }
            }
        }
        .navigationBarHidden(true)
        .photosPicker(isPresented: $showingImagePicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let newItem = newItem {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            stateProvider.profileImage = uiImage
                            stateProvider.saveProfileData()
                        }
                    }
                }
            }
        }
        .onAppear {
            tempNickname = stateProvider.profileNickname
        }
        .alert("Reset Statistics", isPresented: $showResetAlert) {
            Button("Reset", role: .destructive) {
                stateProvider.resetStats()
                showToastMessage("Statistics have been reset successfully!")
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to reset all your activity statistics? This action cannot be undone.")
        }
    }
    
    func shareApp() {
        let shareText = "Check out Dubai Parks Booking - the best way to book your Dubai adventure!"
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
    
    func formatMemberSince() -> String {
        let installDate = UserDefaults.standard.object(forKey: "installDate") as? Date ?? Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: installDate)
    }
    
    func showToastMessage(_ message: String) {
        toastMessage = message
        withAnimation(.easeInOut(duration: 0.3)) {
            showToast = true
        }
        
        // Auto-hide after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showToast = false
            }
        }
    }
    
}

struct ProfileInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(hex: "454545"))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "454545"))
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}

struct ProfileEventCard: View {
    let event: Event
    @StateObject private var stateProvider = StateProvider.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Event Image
            if let image = event.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 80)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 140, height: 80)
                    .cornerRadius(8)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(event.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "454545"))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Like indicator
                    if stateProvider.isEventLiked(event.id.uuidString) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.red)
                    }
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "703CF1"))
                    
                    Text(formatEventDate(event.date))
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                HStack {
                    Image(systemName: "location")
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "703CF1"))
                    
                    Text(event.location)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .frame(width: 140)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
    
    private func formatEventDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}
