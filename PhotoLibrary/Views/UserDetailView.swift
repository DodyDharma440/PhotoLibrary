//
//  UserDetailView.swift
//  PhotoLibrary
//
//  Created by Dodi Aditya on 05/11/23.
//

import SwiftUI
import MapKit

struct UserDetailView: View {
    let locationFetcher = LocationFetcher()
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    var user: User
    
    @State private var isShowDelete = false
    @State private var activeTab = 0
    
    var body: some View {
        List {
            Section(header: Text("Profile Picture")) {
                ZStack {
                    if let image = user.wrappedImage {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.black.opacity(0.1))
                        Text("No image.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } // ZStack
                .frame(width: 200, height: 200)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            } // Section
            
            Section(header: Text("Details")) {
                Picker("", selection: $activeTab) {
                    Text("Profile")
                        .tag(0)
                    Text("Event Location")
                        .tag(1)
                }
                .pickerStyle(.segmented)
                
                switch activeTab {
                case 0:
                    dataGroup("Name", value: user.wrappedName)
                    dataGroup("Email", value: user.wrappedEmail)
                    dataGroup("Bio", value: user.wrappedBio)
                case 1:
                    if let coordinate = user.coordinate {
                        EventMap(coordinate: coordinate)
                    } else {
                        Text("Map is not available")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                default:
                    EmptyView()
                }
            } // Section
        } // List
        .navigationTitle(user.wrappedName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Delete") {
                isShowDelete = true
            } // Button
            .tint(.red)
        } // Toolbar
        .alert("Delete User", isPresented: $isShowDelete) {
            Button("Cancel", role: .cancel) { }
            
            Button("Yes, Delete", role: .destructive) {
                let url = FileManager.default.documentDirectory.appendingPathComponent(user.imageId ?? "")
                try? FileManager.default.removeItem(at: url)
                
                moc.delete(user)
                try? moc.save()
                dismiss()
            }
        } message: {
            Text("Are you sure to delete user with name \(user.wrappedName)?")
        } // Alert
    }
}

extension UserDetailView {
    func dataGroup(_ label: String, value: String) -> some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(value)
        }
    }
}

extension UserDetailView {
    
    
    struct EventMap: View {
        var coordinate: CLLocationCoordinate2D
        @State private var region: MKCoordinateRegion
        
        init(coordinate: CLLocationCoordinate2D) {
            self.coordinate = coordinate
            _region = State(wrappedValue: MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
        }
        
        var body: some View {
            Map(
                coordinateRegion: $region,
                annotationItems: [AnnotationItem(coordinate: coordinate)],
                annotationContent: { item in
                    MapMarker(coordinate: item.coordinate)
                })
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.vertical, 4)
            
        }
        
        struct AnnotationItem: Identifiable {
            var id = UUID()
            var coordinate: CLLocationCoordinate2D
        }
    }
}

#Preview {
    NavigationStack {
        UserDetailView(user: User.example)
            .moc()
    }
}
