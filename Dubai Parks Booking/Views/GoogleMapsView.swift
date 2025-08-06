import SwiftUI
import MapKit

struct GoogleMapsView: UIViewRepresentable {
    let parks: [Park]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        mapView.showsCompass = true
        mapView.showsScale = true
        
        let dubaiParksRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 24.919, longitude: 55.006),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        mapView.setRegion(dubaiParksRegion, animated: false)
        
        addParkMarkers(to: mapView)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        addParkMarkers(to: uiView)
    }
    
    private func addParkMarkers(to mapView: MKMapView) {
        for park in parks {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: park.latitude,
                longitude: park.longitude
            )
            annotation.title = park.name
            annotation.subtitle = park.description
            mapView.addAnnotation(annotation)
        }
    }
}

struct EmbeddedMapView: View {
    @State private var showingFullMap = false
    
    let dubaiParks = [
        Park(
            name: "MOTIONGATE Dubai",
            imageName: "1",
            description: "Hollywood-inspired theme park featuring thrilling rides and attractions based on popular movies.",
            highlights: [
                "DreamWorks Zone with Shrek and Madagascar attractions",
                "Columbia Pictures Zone with Ghostbusters experiences",
                "Lionsgate Zone featuring The Hunger Games rides",
                "Smurfs Village for younger children"
            ],
            latitude: 24.921835,
            longitude: 55.003883
        ),
        Park(
            name: "Real Madrid World",
            imageName: "2",
            description: "The world's first football club theme park with Real Madrid-themed attractions.",
            highlights: [
                "Real Madrid Experience with interactive exhibits",
                "Training Academy with football skill challenges",
                "Trophy Room with club history displays",
                "Bernabéu Stadium virtual experiences"
            ],
            latitude: 24.917456,
            longitude: 55.007458
        ),
        Park(
            name: "LEGOLAND Dubai",
            imageName: "3",
            description: "Ultimate theme park for families with children aged 2-12 featuring LEGO-themed attractions.",
            highlights: [
                "LEGO City with kid-sized real-life experiences",
                "Adventure land with ancient ruins exploration",
                "Kingdoms with medieval castles and dragons",
                "MINILAND with Middle Eastern landmarks"
            ],
            latitude: 24.917456,
            longitude: 55.007458
        ),
        Park(
            name: "LEGOLAND Water Park Dubai",
            imageName: "4",
            description: "Water park designed for children aged 2-12 with over 20 water slides and attractions.",
            highlights: [
                "Build-A-Raft River experience",
                "LEGO Wave Pool for young swimmers",
                "Imagination Station with 60+ features",
                "Duplo Splash Safari for toddlers"
            ],
            latitude: 24.918836,
            longitude: 55.009677
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                GoogleMapsView(parks: dubaiParks)
                    .frame(height: 250)
                    .cornerRadius(15)
                    .clipped()
                
                Button(action: {
                    showingFullMap = true
                }) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                }
                .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "map.fill")
                        .foregroundColor(Color(hex: "703CF1"))
                    Text("Dubai Parks & Resorts")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                Text("Interactive map showing all 4 theme parks in Dubai Parks and Resorts complex")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 16) {
                    mapLegendItem(color: .red, text: "MOTIONGATE")
                    mapLegendItem(color: .blue, text: "Real Madrid")
                }
                
                HStack(spacing: 16) {
                    mapLegendItem(color: .green, text: "LEGOLAND")
                    mapLegendItem(color: .cyan, text: "Water Park")
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .fullScreenCover(isPresented: $showingFullMap) {
            FullScreenMapView(parks: dubaiParks, isPresented: $showingFullMap)
        }
    }
    
    private func mapLegendItem(color: Color, text: String) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct FullScreenMapView: View {
    let parks: [Park]
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            GoogleMapsView(parks: parks)
                .navigationTitle("Dubai Parks Map")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            isPresented = false
                        }
                    }
                }
        }
    }
}