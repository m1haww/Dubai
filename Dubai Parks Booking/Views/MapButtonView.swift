import SwiftUI
import MapKit

struct MapButtonView: View {
    let locationName: String
    let latitude: Double
    let longitude: Double
    @State private var showingMapView = false
    
    private var park: Park {
        Park(
            name: locationName,
            imageName: "1", // Default image
            description: "Located in Dubai Parks & Resorts",
            highlights: [],
            latitude: latitude,
            longitude: longitude
        )
    }
    
    var body: some View {
        Button(action: {
            showingMapView = true
        }) {
            HStack {
                Image(systemName: "map.fill")
                    .font(.system(size: 18))
                Text("View Location")
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
        .fullScreenCover(isPresented: $showingMapView) {
            ParkMapView(park: park)
        }
    }
}

struct MapButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MapButtonView(locationName: "MOTIONGATE Dubai", latitude: 24.921835, longitude: 55.003883)
    }
}
