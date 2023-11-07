//
//  AddUserView.swift
//  PhotoLibrary
//
//  Created by Dodi Aditya on 05/11/23.
//

import SwiftUI

struct AddUserView: View {
    let locationFetcher = LocationFetcher()
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm = ViewModel()
    
    var isValid: Bool {
        vm.isValid()
    }
    
    var body: some View {
        VStack {
            Form {
                Section("Profile Picture") {
                    ZStack {
                        if let image = vm.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.black.opacity(0.1))
                            Text("Tap to select image")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    } // ZStack
                    .frame(width: 200, height: 200)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 10)
                    .onTapGesture {
                        vm.isShowPicker = true
                    }
                } // Section
                
                Section("Details") {
                    TextField("Name", text: $vm.name)
                        .autocorrectionDisabled()
                    TextField("Email", text: $vm.email)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                    Textarea(value: $vm.bio, placeholder: "Write bio here...")
                        .padding(.bottom, 4)
                }
                
                Section {
                    Button("Save") {
                        let user = User(context: moc)
                        vm.createUser(user: user) {
                            try? moc.save()
                            dismiss()
                        }
                    } // Button
                    .frame(maxWidth: .infinity)
                    .disabled(!isValid)
                } // Section
            } // Form
        } // VStack
        .navigationTitle("Add new user")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $vm.isShowPicker) {
            ImagePicker(image: $vm.selectedImage)
        }
        .onAppear {
            locationFetcher.requestLocation { location in
                vm.coordinate = location.coordinate
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddUserView()
            .moc()
    }
}
