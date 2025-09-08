import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let onboardingCompleted: () -> Void
    
    var body: some View {
            TabView(selection: $currentPage) {
                OnboardingPageView(
                    title: "Exclusive Dubai \n Deal!",
                    subtitle: "Experience underwater wonders for just 10 AED.",
                    subtitle2: nil,
                    buttonText: "Next",
                    isLastPage: false,
                    backgroundImage: "first"
                ) {
                    withAnimation {
                        currentPage = 1
                    }
                }
                .tag(0)
                
                OnboardingPageView(
                    title: "Your Ticket to Underwater Adventures",
                    subtitle: "Your Ticket to Underwater Adventures",
                    subtitle2: "This special price is available only through our app",
                    buttonText: "Next",
                    isLastPage: false,
                    backgroundImage: "second"
                ) {
                    withAnimation {
                        currentPage = 2
                    }
                }
                .tag(1)
                
                OnboardingPageView(
                    title: "Start Your Adventure Today",
                    subtitle: "Tap below to book your ticket quickly and easily",
                    subtitle2: nil,
                    buttonText: "Book Ticket",
                    isLastPage: true,
                    backgroundImage: "third"
                ) {
                    onboardingCompleted()
                }
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea(.all)
            .overlay(
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        if index == currentPage {
                            // Active indicator - capsule shape
                            Capsule()
                                .fill(Color.blue)
                                .frame(width: 24, height: 8)
                        } else {
                            // Inactive indicator - circle
                            Circle()
                                .fill(Color.blue.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 60 : 50),
                alignment: .bottom
            )
    }
}

struct OnboardingPageView: View {
    let title: String
    let subtitle: String
    let subtitle2: String?
    let buttonText: String
    let isLastPage: Bool
    let backgroundImage: String
    let action: () -> Void
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad layout
            GeometryReader { geometry in
                ZStack {
                    // Background image
                    Image(backgroundImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .ignoresSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        Spacer()
                        Spacer()
                        Spacer()
                        
                        // Title and subtitle positioned lower
                        VStack(spacing: 8) {
                            Text(title)
                                .font(.system(size: 48, weight: .bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .padding(.horizontal, 80)
                            
                            Text(subtitle)
                                .font(.system(size: 24, weight: .semibold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(subtitle2 != nil ? Color(hex: "0092D0") : .black)
                                .padding(.horizontal, 80)
                            
                            if let subtitle2 = subtitle2 {
                                Text(subtitle2)
                                    .font(.system(size: 24, weight: .semibold))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 80)
                            }
                        }
                        .padding(.bottom, 100)
                        
                        // Button
                        Button(action: action) {
                            Image("Buttonn")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                        }
                        .padding(.bottom, 180)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            // iPhone layout - simple and original
            ZStack {
                // Background image
                Image(backgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    Spacer()
                    Spacer()
                    
                    // Title and subtitle positioned lower
                    VStack(spacing: 8) {
                        Text(title)
                            .font(.system(size: 32, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .padding(.horizontal, 40)
                        
                        Text(subtitle)
                            .font(.system(size: 18, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(subtitle2 != nil ? Color(hex: "0092D0") : .black)
                            .padding(.horizontal, 40)
                        
                        if let subtitle2 = subtitle2 {
                            Text(subtitle2)
                                .font(.system(size: 18, weight: .semibold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .padding(.horizontal, 40)
                        }
                    }
                    .padding(.bottom, 60)
                    
                    // Button
                    Button(action: action) {
                        Image("Buttonn")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                    }
                    .padding(.bottom, 120)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
