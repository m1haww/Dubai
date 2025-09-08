import SwiftUI

struct DubaiAquariumDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    Button(action: {
                        // Post notification to go back to ParksView
                        NotificationCenter.default.post(name: Notification.Name("DismissAquarium"), object: nil)
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                    .contentShape(Rectangle())
                    
                    Text("Dubai Aquarium & Underwater Zoo")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                    
                    Spacer()
                }
                .frame(height: 60)
                .background(Color(hex: "703CF1"))
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        // Header Image
                        Image("3")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                        
                        // Map Button
                        MapButtonView(
                            locationName: "Georgia Aquarium",
                            latitude: 33.7634,
                            longitude: -84.3951
                        )
                        .padding(.top, -10)
                        
                        VStack(alignment: .leading, spacing: 24) {
                            // Section 1: Beneath The Sea
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Beneath The Sea")
                                    .font(.system(size: 24, weight: .light))
                                    .foregroundColor(Color(hex: "454545"))
                                
                                Text("Unveiling Ocean Mysteries")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color(hex: "2E2E2E"))
                                
                                Text("Add a stunning new dimension to your experience at Dubai Aquarium & Underwater Zoo by entering the larger-than-life aquarium tunnel. Step into the diversity of the open ocean as you walk through this extraordinary 48-metre-long tunnel, 11 metres below the surface. Watch colourful fish dart between coral formations and witness rays glide gracefully overhead.")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: "454545"))
                                    .lineSpacing(8)
                                
                                // 3 Facts for Section 1
                                VStack(alignment: .leading, spacing: 20) {
                                    HighlightRow(
                                        title: "Walk Amongst Marine Life",
                                        description: "Feel the magic as you become part of this underwater world, surrounded by a vibrant tapestry of fish and rays."
                                    )
                                    
                                    HighlightRow(
                                        title: "Witness the Feeding Frenzy",
                                        description: "Witness a thrilling spectacle as skilled divers engage in feeding sessions with sharks and rays, offering a glimpse into their fascinating feeding behaviours."
                                    )
                                    
                                    HighlightRow(
                                        title: "Discover Tranquillity in the Deep",
                                        description: "Immerse yourself in the peaceful ambiance of the tunnel. Escape the everyday as you observe the movements of the underwater world."
                                    )
                                }
                                .padding(.top, 8)
                            }
                            
                            Divider()
                                .padding(.vertical, 16)
                            
                            // Section 2: Aquatic Encounters
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Aquatic Encounters")
                                    .font(.system(size: 24, weight: .light))
                                    .foregroundColor(Color(hex: "454545"))
                                
                                Text("Journey Through Diverse Ecosystems")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color(hex: "2E2E2E"))
                                
                                Text("Underwater Zoo showcases the spectacular diversity of life in our rivers and oceans through three distinct ecological zones – Rainforest, Rocky Shore and Living Ocean. Watch out for a vast array of aquatic animals across 40 individual displays:")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: "454545"))
                                    .lineSpacing(8)
                                    .padding(.top, 4)
                                
                                // 3 Facts for Section 2
                                VStack(alignment: .leading, spacing: 20) {
                                    HighlightRow(
                                        title: "Rainforest",
                                        description: "Journey through lush vegetation where freshwater fish thrive alongside amphibians and reptiles. Piranhas, giant catfish, playful otters and water rats are just some of the animals you'll meet here."
                                    )
                                    
                                    HighlightRow(
                                        title: "Rocky Shore",
                                        description: "Where land meets sea, experience rugged beauty where only the toughest survive. Reach out and touch some of the hardier rock pool inhabitants for a truly immersive experience."
                                    )
                                    
                                    HighlightRow(
                                        title: "Living Ocean",
                                        description: "Venture into this underwater world where coral reefs shimmer and graceful sharks patrol the expanse."
                                    )
                                }
                                .padding(.top, 8)
                            }
                            
                            Divider()
                                .padding(.vertical, 16)
                            
                            // Section 3: Amazing Facts
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Amazing Facts")
                                    .font(.system(size: 24, weight: .light))
                                    .foregroundColor(Color(hex: "454545"))
                                
                                Text("Did You Know?")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color(hex: "2E2E2E"))
                                
                                Text("Dubai Aquarium & Underwater Zoo holds several records and fascinating facts that make it one of the most impressive aquatic attractions in the world.")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: "454545"))
                                    .lineSpacing(8)
                                    .padding(.top, 4)
                                
                                // 3 Facts for Section 3
                                VStack(alignment: .leading, spacing: 20) {
                                    HighlightRow(
                                        title: "World's Largest Viewing Panel",
                                        description: "Our 10-million litre tank features one of the world's largest acrylic viewing panels, measuring 32.88 meters wide and 8.3 meters tall."
                                    )
                                    
                                    HighlightRow(
                                        title: "Home to 33,000+ Animals",
                                        description: "We house over 33,000 aquatic animals representing more than 140 species, including over 300 sharks and rays combined."
                                    )
                                    
                                    HighlightRow(
                                        title: "Meet King Croc",
                                        description: "Our famous King Croc weighs over 750kg and is over 40 years old - one of the largest crocodiles in captivity."
                                    )
                                }
                                .padding(.top, 8)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct HighlightRow: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title + ":")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: "703CF1"))
            
            Text(description)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "454545"))
                .lineSpacing(6)
        }
    }
}

#Preview {
    DubaiAquariumDetailView()
}