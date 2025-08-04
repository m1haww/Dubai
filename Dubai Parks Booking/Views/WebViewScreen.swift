import SwiftUI

struct WebViewScreen: View {
    let url: String
    let parkName: String
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var stateProvider = StateProvider.shared
    @State private var showReviewAlert = false
    
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
                    
                    // Review button in app bar
                    Button(action: {
                        showReviewAlert = true
                    }) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing)
                }
                .frame(height: 60)
                .background(Color(hex: "703CF1"))
                
                // WebView
                WebViewRepresentable(url: url, parkName: parkName)
            }
        }
        .navigationBarHidden(true)
        .alert("Leave a Review", isPresented: $showReviewAlert) {
            Button("Leave Review") {
                stateProvider.addReview()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("How was your experience at \(parkName)?")
        }
    }
}

#Preview {
    WebViewScreen(url: "https://domen.com/page1.html", parkName: "Test Park")
}