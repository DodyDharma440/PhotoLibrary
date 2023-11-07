//
//  PhotoLibraryApp.swift
//  PhotoLibrary
//
//  Created by Dodi Aditya on 05/11/23.
//

import SwiftUI

@main
struct PhotoLibraryApp: App {
    @StateObject private var controller = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, controller.container.viewContext)
        }
    }
}
