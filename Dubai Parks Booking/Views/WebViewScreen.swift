import SwiftUI

struct WebViewScreen: View {
    let url: String
    let parkName: String
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
                    
                    Text(parkName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                    
                    Spacer()
                }
                .frame(height: 60)
                .background(Color(hex: "703CF1"))
                
                // WebView
                WebViewRepresentable(url: url, parkName: parkName)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    WebViewScreen(url: "https://domen.com/page1.html", parkName: "Test Park")
}