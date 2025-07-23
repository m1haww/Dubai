import SwiftUI

struct ParksView: View {
    let parks = [
        Park(
            name: "Dubai Aquarium",
            imageName: "1",
            description: "Underwater Zoo showcases the spectacular diversity of life in our rivers and oceans through three distinct ecological zones – Rainforest, Rocky Shore and Living Ocean. Watch out for a vast array of aquatic animals across 40 individual displays.",
            highlights: [
                "Rainforest: Journey through lush vegetation where freshwater fish thrive alongside amphibians and reptiles. Piranhas, giant catfish, playful otters and water rats are just some of the animals you'll meet here.",
                "Rocky Shore: Where land meets sea, experience rugged beauty where only the toughest survive. Reach out and touch some of the hardier rock pool inhabitants for a truly immersive experience.",
                "Living Ocean: Venture into this underwater world where coral reefs shimmer and graceful sharks patrol the expanse.",
                "Get Up Close and Personal: Get nose-to-nose with our incredible inhabitants including playful otters and mischievous penguins!"
            ]
        ),
        Park(
            name: "The Green Planet",
            imageName: "2",
            description: "An indoor rainforest with over 3,000 plants and animals. Experience the enchanting world of the tropics in the heart of Dubai.",
            highlights: []
        ),
        Park(
            name: "Aquaventure Atlantis",
            imageName: "3",
            description: "Dubai's most exciting waterpark with record-breaking rides and slides. Get your adrenaline pumping at the Middle East's leading waterpark.",
            highlights: []
        ),
        Park(
            name: "IMG Worlds of Adventure",
            imageName: "4",
            description: "The world's largest indoor theme park spanning 1.5 million square feet. Experience four epic zones with thrilling rides and attractions.",
            highlights: []
        )
    ]
    
    private func getWebURL(for park: Park) -> String {
        switch park.name {
        case "Dubai Aquarium":
            return "https://dubaiparks.click/1"
        case "The Green Planet":
            return "https://dubaiparks.click/2"
        case "Aquaventure Atlantis":
            return "https://dubaiparks.click/3"
        case "IMG Worlds of Adventure":
            return "https://dubaiparks.click/4"
        default:
            return "https://dubaiparks.click/1"
        }
    }
    
    @State private var showNavigationBar = true
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Navigation Bar
                    HStack {
                        Image("Good")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .padding(.leading)
                        Text("Dubai Parks Booking")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                        
                        Spacer()
                    }
                    .frame(height: 60)
                    .background(Color(hex: "703CF1"))
                    
                    // Scrollable content
                    ScrollView {
                        VStack(spacing: 0) {
                            // Title
                            HStack {
                                Text("Parks")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                    .padding(.top, 20)
                                    .padding(.bottom, 10)
                                    .foregroundColor(Color(hex: "454545"))
                                Spacer()
                            }
                            
                            // Parks List
                            VStack(spacing: 25) {
                                ForEach(parks) { park in
                                    NavigationLink(destination: WebViewScreen(url: getWebURL(for: park), parkName: park.name)) {
                                        ParkCardView(park: park)
                                            .padding(.horizontal)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.bottom, 32)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Preview only available in iOS 13+
