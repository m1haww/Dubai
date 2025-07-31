import SwiftUI

struct ImageCarouselView: View {
    let baseImageName: String
    @State private var currentIndex = 0
    
    private var imageNames: [String] {
        return (1...5).map { "\(baseImageName)-\($0)" }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Image Carousel
            TabView(selection: $currentIndex) {
                ForEach(0..<5, id: \.self) { index in
                    Image(imageNames[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 250)
            
            // Custom Page Indicators
            HStack(spacing: 8) {
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color(hex: "703CF1") : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentIndex ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: currentIndex)
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 8)
        }
    }
}

struct ImageCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCarouselView(baseImageName: "1")
    }
}