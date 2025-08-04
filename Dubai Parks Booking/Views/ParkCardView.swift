import SwiftUI

struct ParkCardView: View {
    let park: Park
    @StateObject private var stateProvider = StateProvider.shared
    
    var body: some View {
        ZStack {
            // Background Image
            Image(park.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .cornerRadius(16)
            
            // Gradient Overlay
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(16)
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        if stateProvider.isEventLiked(park.name) {
                            stateProvider.unlikeEvent(park.name)
                            stateProvider.removeFromFavorites(park.name)
                        } else {
                            stateProvider.likeEvent(park.name)
                            stateProvider.addToFavorites(park.name)
                        }
                    }) {
                        let isFavorite = stateProvider.isEventLiked(park.name)
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 20))
                            .foregroundColor(isFavorite ? .red : .white)
                            .padding(8)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding(.top, 16)
                    .padding(.trailing, 16)
                }
                
                Spacer()
                
                HStack {
                    Text(park.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    Image("Button")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                }
            }
        }
        .padding(10)
    }
}
