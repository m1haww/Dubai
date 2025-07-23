import SwiftUI

// Placeholder views to make the app compile
struct HomeView: View {
    var body: some View {
        ParksView() // Use existing ParksView
    }
}

struct PromptsView: View {
    var body: some View {
        Text("Tasks for AI")
            .foregroundColor(.black)
    }
}

struct HistoryView: View {
    var body: some View {
        Text("History")
            .foregroundColor(.black)
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings")
            .foregroundColor(.black)
    }
}

struct ShareView: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ChatView: View {
    let prompt: String
    let modelType: String
    let chatHistory: [String]
    
    var body: some View {
        Text("Chat View")
            .foregroundColor(.black)
    }
}

struct SummaryView: View {
    let text: String
    let isLyrics: Bool
    
    var body: some View {
        Text("Summary View")
            .foregroundColor(.black)
    }
}

struct ImageDataView: View {
    let image: UIImage
    
    var body: some View {
        Text("Image View")
            .foregroundColor(.black)
    }
}

struct AudioDataView: View {
    let audioFilePath: Data
    
    var body: some View {
        Text("Audio View")
            .foregroundColor(.black)
    }
}

// Placeholder card views
struct YoutubeSummaryCard: View {
    var body: some View {
        EmptyView()
    }
}

struct ImageGenerationPopup: View {
    var body: some View {
        EmptyView()
    }
}

struct LyricsGenerationPopup: View {
    var body: some View {
        EmptyView()
    }
}

struct PDFSummaryCard: View {
    var body: some View {
        EmptyView()
    }
}

struct TextToSpeechCard: View {
    var body: some View {
        EmptyView()
    }
}

struct CustomAlertView: View {
    var body: some View {
        EmptyView()
    }
}

// Missing constants
struct Colors {
    static let shared = Colors()
    let backgroundColor = Color.white
    let lightGreen = Color.green
}

struct Fonts {
    static let shared = Fonts()
    let interRegular = "Inter-Regular"
    let interMedium = "Inter-Medium"
    let instrumentSansSemiBold = "InstrumentSans-SemiBold"
}