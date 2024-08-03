//
//  OAuth2TokenStorage.swift
//  Image Feed
//
//  Created by Гена Утин on 31.07.2024.
//

import Foundation

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private let storage = UserDefaults.standard
    private enum StorageKeys: String {
        case token
    }
    
    var token: String? {
        get {
            storage.string(forKey: StorageKeys.token.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: StorageKeys.token.rawValue)
        }
    }
}
