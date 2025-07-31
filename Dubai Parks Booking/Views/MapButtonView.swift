import SwiftUI

struct MapButtonView: View {
    let locationName: String
    let latitude: Double
    let longitude: Double
    
    private var mapURL: String {
        let encodedLocation = locationName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "https://maps.google.com/?q=\(latitude),\(longitude)(\(encodedLocation))"
    }
    
    private func openMaps() {
        print("🗺️ Maps button tapped!")
        
        // Check if app is in active state before opening URL
        guard UIApplication.shared.applicationState == .active else {
            print("⚠️ App not active, delaying URL opening...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.openMaps()
            }
            return
        }
        
        // Create URL with full location name including "Dubai" for better search results
        let fullLocationName = "\(locationName) Dubai"
        let encodedLocation = fullLocationName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let webMapURL = "https://www.google.com/maps/search/?api=1&query=\(encodedLocation)"
        
        print("🌐 Opening URL: \(webMapURL)")
        
        guard let webURL = URL(string: webMapURL) else {
            print("❌ Failed to create URL")
            return
        }
        
        // Ensure we're on main thread and app is still active
        DispatchQueue.main.async {
            UIApplication.shared.open(webURL, options: [:]) { success in
                print(success ? "✅ Successfully opened maps for \(self.locationName)" : "❌ Failed to open maps for \(self.locationName)")
            }
        }
    }
    
    var body: some View {
        // Force iPad to use the same approach as iPhone
        if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad-specific implementation with forced touch handling
            ZStack {
                // Background that captures all touches
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        print("🔴 BACKGROUND TAP for \(locationName)!")
                        openMaps()
                    }
                
                HStack {
                    Image(systemName: "map.fill")
                        .font(.system(size: 18))
                    Text("See on Google Maps")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity, minHeight: 60)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(hex: "703CF1"))
                )
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                .allowsHitTesting(false)  // Let background handle touches
            }
            .frame(maxWidth: .infinity, minHeight: 80)  // Extra large touch area
            .background(Color.yellow.opacity(0.1))  // Debug: different color per button
            .clipped()
            .padding(.horizontal)
            .padding(.vertical, 10)  // More spacing
            .onAppear {
                print("📍 iPad MapButtonView appeared for: \(locationName)")
            }
        } else {
            // iPhone implementation - simple and working
            Button(action: openMaps) {
                HStack {
                    Image(systemName: "map.fill")
                        .font(.system(size: 18))
                    Text("See on Google Maps")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(hex: "703CF1"))
                )
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal)
        }
    }
}

struct MapButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MapButtonView(locationName: "Georgia Aquarium", latitude: 33.7634, longitude: -84.3951)
    }
}
