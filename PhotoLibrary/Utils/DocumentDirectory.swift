//
//  DocumentDirectory.swift
//  PhotoLibrary
//
//  Created by Dodi Aditya on 06/11/23.
//

import Foundation

extension FileManager {
    var documentDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
