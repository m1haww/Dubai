import SwiftUI

struct EventsView: View {
    @StateObject private var stateProvider = StateProvider.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var showingCreateEvent = false
    
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
                    
                    Text("My Events")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                    
                    Spacer()
                    
                    Button(action: {
                        showingCreateEvent = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing)
                }
                .frame(height: 60)
                .background(Color(hex: "703CF1"))
                
                // Events Content
                if stateProvider.events.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text("No Events Yet")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Color(hex: "454545"))
                        
                        Text("Create your first event to get started!")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            showingCreateEvent = true
                        }) {
                            Text("Create Event")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color(hex: "703CF1"))
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(stateProvider.events.sorted(by: { $0.date < $1.date })) { event in
                                NavigationLink(destination: EventDetailView(event: event)) {
                                    EventCardView(event: event)
                                        .padding(.horizontal, 16)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingCreateEvent) {
            CreateEventView()
        }
    }
}

struct EventCardView: View {
    let event: Event
    @StateObject private var stateProvider = StateProvider.shared
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Event Image
            if let image = event.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .cornerRadius(12)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(event.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "454545"))
                    
                    Spacer()
                    
                    // Like indicator
                    if stateProvider.isEventLiked(event.id.uuidString) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                    }
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "703CF1"))
                    
                    Text(formatDate(event.date))
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Image(systemName: "location")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "703CF1"))
                    
                    Text(event.location)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Text(event.description)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "454545"))
                    .lineLimit(3)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .alert("Delete Event", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                stateProvider.deleteEvent(event)
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this event?")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}