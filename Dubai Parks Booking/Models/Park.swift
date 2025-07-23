import Foundation

struct Park: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let description: String
    let highlights: [String]
}
