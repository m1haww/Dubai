import SwiftUI
import PhotosUI

struct CreateEventView: View {
    @StateObject private var stateProvider = StateProvider.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var date = Date()
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Navigation Bar
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Cancel")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        .padding(.leading)
                        
                        Spacer()
                        
                        Text("Create Event")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            saveEvent()
                        }) {
                            Text("Save")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .disabled(title.isEmpty || description.isEmpty || location.isEmpty)
                        .opacity(title.isEmpty || description.isEmpty || location.isEmpty ? 0.5 : 1.0)
                        .padding(.trailing)
                    }
                    .frame(height: 60)
                    .background(Color(hex: "703CF1"))
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Image Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Event Image")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(hex: "454545"))
                                
                                Button(action: {
                                    showingImagePicker = true
                                }) {
                                    if let selectedImage = selectedImage {
                                        Image(uiImage: selectedImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 200)
                                            .clipped()
                                            .cornerRadius(12)
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.1))
                                            .frame(height: 200)
                                            .cornerRadius(12)
                                            .overlay(
                                                VStack(spacing: 8) {
                                                    Image(systemName: "camera.fill")
                                                        .font(.system(size: 30))
                                                        .foregroundColor(Color(hex: "703CF1"))
                                                    
                                                    Text("Add Photo")
                                                        .font(.system(size: 16, weight: .medium))
                                                        .foregroundColor(Color(hex: "703CF1"))
                                                }
                                            )
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            // Title Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Event Title")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(hex: "454545"))
                                
                                TextField("Enter event title", text: $title)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.system(size: 16))
                            }
                            
                            // Description Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(hex: "454545"))
                                
                                TextEditor(text: $description)
                                    .frame(height: 100)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    .font(.system(size: 16))
                            }
                            
                            // Date Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date & Time")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(hex: "454545"))
                                
                                DatePicker("Select date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .labelsHidden()
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.1))
                                    )
                            }
                            
                            // Location Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Location")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(hex: "454545"))
                                
                                TextField("Enter location", text: $location)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.system(size: 16))
                            }
                            
                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .photosPicker(isPresented: $showingImagePicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let newItem = newItem {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    }
                }
            }
        }
    }
    
    private func saveEvent() {
        let newEvent = Event(
            title: title,
            description: description,
            date: date,
            location: location,
            image: selectedImage
        )
        
        stateProvider.addEvent(newEvent)
        presentationMode.wrappedValue.dismiss()
    }
}