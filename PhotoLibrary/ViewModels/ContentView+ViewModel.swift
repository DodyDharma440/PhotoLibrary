//
//  ContentView+ViewModel.swift
//  PhotoLibrary
//
//  Created by Dodi Aditya on 05/11/23.
//

import Foundation

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var isShowAdd = false
        @Published var searchValue = ""
        
        @Published var isShowDelete = false
        @Published var shouldDeletedUser: User?
        
        func showAlertDelete(user: User) {
            isShowDelete = true
            shouldDeletedUser = user
        }
        
        func hideAlertDelete() {
            isShowDelete = false
            shouldDeletedUser = nil
        }
    }
}
