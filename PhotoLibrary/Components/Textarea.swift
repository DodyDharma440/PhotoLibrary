//
//  Textarea.swift
//  PhotoLibrary
//
//  Created by Dodi Aditya on 05/11/23.
//

import SwiftUI

struct Textarea: View {
    var placeholder = ""
    @Binding var value: String
    
    @FocusState private var isFocus: Bool
    
    init(value: Binding<String>) {
        self._value = value
    }
    
    init(value: Binding<String>, placeholder: String) {
        self.placeholder = placeholder
        self._value = value
    }
    
    var isEmpty: Bool {
        value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $value)
                .focused($isFocus)
            
            if isEmpty {
                HStack {
                    Text(placeholder)
                        .opacity(0.5)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 5)
                    Spacer()
                } // HStack
                .padding(.top, 10)
                .onTapGesture {
                    isFocus.toggle()
                }
            } // Condition
        } // ZStack
        .padding(.leading, -4)
    }
}

#Preview {
    Textarea(value: .constant(""))
}
