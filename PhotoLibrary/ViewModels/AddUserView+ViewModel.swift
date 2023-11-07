//
//  AddUserView+ViewModel.swift
//  PhotoLibrary
//
//  Created by Dodi Aditya on 05/11/23.
//

import SwiftUI
import CoreLocation

extension AddUserView {
    @MainActor class ViewModel: ObservableObject {
        @Published var name = ""
        @Published var email = ""
        @Published var bio = ""
        @Published var image: Image?
        @Published var coordinate: CLLocationCoordinate2D?
        @Published var selectedImage: UIImage? {
            didSet {
                Task { @MainActor in
                    loadPreviewImage()
                }
            }
        }
        
        @Published var isShowPicker = false
        
        func loadPreviewImage() {
            if let selectedImage = selectedImage {
                image = Image(uiImage: selectedImage)
            }
        }
        
        func createUser(user: User, completion: () -> Void) {
            user.id = .init()
            user.name = name
            user.email = email
            user.bio = bio
            
            let imageId = "\(UUID())-\(name).jpg"
            let url = FileManager.default.documentDirectory.appendingPathComponent(imageId)
            
            if let jpegData = selectedImage?.jpegData(compressionQuality: 0.8) {
                try? jpegData.write(to: url, options: [.atomic, .completeFileProtection])
                user.imageId = imageId
            }
            
            if let coordinate = coordinate {
                user.latitude = NSNumber(value: coordinate.latitude)
                user.longitude = NSNumber(value: coordinate.longitude)
            }
            
            completion()
        }
        
        func isValid() -> Bool {
            !name.isEmpty && !email.isEmpty && email.isEmail
        }
    }
}
