import SwiftUI
import MapKit

struct ParkMapView: View {
    let park: Park
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Map Section
                SingleParkMapView(park: park)
                    .frame(maxHeight: .infinity)
                
                // Park Information Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(park.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Dubai Parks & Resorts")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    Text(park.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .navigationTitle("Location")
            .navigationBarItems(
                leading: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SingleParkMapView: UIViewRepresentable {
    let park: Park
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        mapView.showsCompass = true
        mapView.showsScale = true
        
        // Center on the specific park
        let coordinate = CLLocationCoordinate2D(latitude: park.latitude, longitude: park.longitude)
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        mapView.setRegion(region, animated: false)
        
        // Add marker for this park
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = park.name
        annotation.subtitle = "Dubai Parks & Resorts"
        mapView.addAnnotation(annotation)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update if needed
    }
}