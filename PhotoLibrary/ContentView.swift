//
//  ContentView.swift
//  PhotoLibrary
//
//  Created by Dodi Aditya on 05/11/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var users: FetchedResults<User>
    
    @StateObject var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                if users.isEmpty {
                    Section {
                        VStack {
                            Image(systemName: "rectangle.stack")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Text("User data is empty.")
                                .foregroundStyle(.secondary)
                        } // VStack
                        .padding()
                        .frame(maxWidth: .infinity)
                    } // Section
                } else {
                    ForEach(users, id: \.id) { user in
                        NavigationLink {
                            UserDetailView(user: user)
                        } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    if let image = user.wrappedImage {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    }
                                } // ZStack
                                .frame(width: 50, height: 50)
                                .background(.black.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                
                                VStack(alignment: .leading) {
                                    Text(user.wrappedName)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    
                                    Text(user.wrappedEmail)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                } // VStack
                            } // HStack
                            .padding(.vertical, 4)
                        } // NavigationLink
                    } // Loop
                    .onDelete { indexSet in
                        for i in indexSet {
                            let user = users[i]
                            
                            let url = FileManager.default.documentDirectory.appendingPathComponent(user.imageId ?? "")
                            try? FileManager.default.removeItem(at: url)
                            
                            moc.delete(user)
                            try? moc.save()
                            
                        }
                    }
                } // Condition
            } // List
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                } // ToolbarItem
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AddUserView()
                    } label: {
                        Image(systemName: "plus")
                    }
                } // ToolbarItem
            } // Toolbar
            .searchable(text: $vm.searchValue)
            .onChange(of: vm.searchValue) { newValue in
                if newValue.isEmpty {
                    users.nsPredicate = nil
                } else {
                    users.nsPredicate = NSPredicate(format: "name CONTAINS[c] %@", newValue)
                }
            } // OnChange
        } // Navigation
    }
}

#Preview {
    ContentView()
        .moc()
}
