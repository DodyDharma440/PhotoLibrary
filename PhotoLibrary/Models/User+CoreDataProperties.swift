//
//  User+CoreDataProperties.swift
//  PhotoLibrary
//
//  Created by Dodi Aditya on 05/11/23.
//
//

import SwiftUI
import CoreData
import CoreLocation

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var bio: String?
    @NSManaged public var imageId: String?
    @NSManaged public var email: String?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    
    var wrappedId: UUID {
        id ?? UUID()
    }
    
    var wrappedName: String {
        name ?? "Unknown Name"
    }
    
    var wrappedBio: String {
        bio ?? "-"
    }
    
    var wrappedEmail: String {
        email ?? "Unknown Email"
    }
    
    var wrappedImage: Image? {
        let path = FileManager.default.documentDirectory.appendingPathComponent(imageId ?? "").path()
        
        if let uiImage = UIImage(contentsOfFile: path) {
            return Image(uiImage: uiImage)
        }
        
        return nil
    }
    
    var coordinate: CLLocationCoordinate2D? {
        if let latitude = latitude, let longitude = longitude {
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude), longitude: CLLocationDegrees(truncating: longitude))
        }
        return nil
    }
    
    static var example: User {
        let moc = DataController().container.viewContext
        let user = User(context: moc)
        
        user.id = UUID()
        user.name = "John"
        user.email = "john@gmail.com"
        user.bio = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis dictum venenatis tincidunt. Proin quis dictum mauris, vel tempor est. Proin aliquet ac est sit amet aliquet. Aenean non ante ut eros pharetra sodales. Praesent mollis risus sed tortor efficitur imperdiet. Duis venenatis metus ac tortor fringilla, mollis malesuada leo tristique. Sed varius lacus sed nibh viverra, non iaculis nulla pulvinar. Pellentesque leo mi, placerat eu tristique a, lacinia vel mauris. Cras eu blandit erat, et semper magna. Suspendisse ullamcorper mauris vitae malesuada cursus. Duis pulvinar massa eu mi scelerisque iaculis. Nam molestie mattis dictum. Nulla molestie mollis pharetra."
        
        if let existingUsers = try? moc.fetch(fetchRequest()), let existingUser = existingUsers.first {
            return existingUser
        } else {
            try? moc.save()
            return user
        }
    }
}

extension User : Identifiable {

}
