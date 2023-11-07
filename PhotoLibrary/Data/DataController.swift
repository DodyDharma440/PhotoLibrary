//
//  DataController.swift
//  PhotoLibrary
//
//  Created by Dodi Aditya on 05/11/23.
//

import SwiftUI
import CoreData

struct CoreDataMocModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .environment(\.managedObjectContext, DataController().container.viewContext)
    }
}

extension View {
    func moc() -> some View {
        modifier(CoreDataMocModifier())
    }
}

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "PhotoLibrary")
    
    init() {
        container.loadPersistentStores { description, err in
            if let error = err {
                print("Failed to load Core Data. Error: \(error.localizedDescription)")
            }
        }
        
        self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}

