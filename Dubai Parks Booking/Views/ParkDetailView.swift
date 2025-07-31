import SwiftUI

struct ParkDetailView: View {
    let park: Park
    @Environment(\.presentationMode) var presentationMode
    
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
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding(.leading)
                    }
                    
                    Text(park.name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                    
                    Spacer()
                }
                .frame(height: 60)
                .background(Color(hex: "703CF1"))
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Image Carousel
                        ImageCarouselView(baseImageName: park.imageName)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            // Description
                            Text(park.description)
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "454545"))
                                .lineSpacing(8)
                            
                            // Highlights
                            if !park.highlights.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    ForEach(park.highlights, id: \.self) { highlight in
                                        let components = highlight.split(separator: ":", maxSplits: 1)
                                        if components.count == 2 {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(String(components[0]) + ":")
                                                    .font(.system(size: 18, weight: .semibold))
                                                    .foregroundColor(Color(hex: "703CF1"))
                                                
                                                Text(String(components[1]).trimmingCharacters(in: .whitespaces))
                                                    .font(.system(size: 16))
                                                    .foregroundColor(Color(hex: "454545"))
                                                    .lineSpacing(6)
                                            }
                                        } else {
                                            Text(highlight)
                                                .font(.system(size: 16))
                                                .foregroundColor(Color(hex: "454545"))
                                                .lineSpacing(6)
                                        }
                                    }
                                }
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

#Preview {
    ParkDetailView(park: Park(
        name: "Dubai Aquarium",
        imageName: "1",
        description: "Test description",
        highlights: ["Test highlight"],
        latitude: 33.7634,
        longitude: -84.3951
    ))
}