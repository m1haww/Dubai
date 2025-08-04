import Foundation
import UIKit

struct Event: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var date: Date
    var location: String
    var imageData: Data?
    
    var image: UIImage? {
        get {
            guard let imageData = imageData else { return nil }
            return UIImage(data: imageData)
        }
        set {
            if let newImage = newValue {
                imageData = newImage.jpegData(compressionQuality: 0.8)
            } else {
                imageData = nil
            }
        }
    }
    
    init(title: String, description: String, date: Date, location: String, image: UIImage? = nil) {
        self.title = title
        self.description = description
        self.date = date
        self.location = location
        if let image = image {
            self.imageData = image.jpegData(compressionQuality: 0.8)
        }
    }
}