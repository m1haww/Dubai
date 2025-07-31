import SwiftUI

struct ParkCardView: View {
    let park: Park
    
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
