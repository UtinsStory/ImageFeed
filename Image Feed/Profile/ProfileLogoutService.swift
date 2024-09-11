//
//  ProfileLogoutService.swift
//  Image Feed
//
//  Created by Гена Утин on 08.09.2024.
//

import Foundation
import WebKit
import SwiftKeychainWrapper

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    private init() {}
    
    func logout() {
        cleanCookies()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
        KeychainWrapper.standard.removeAllKeys()
        ProfileService.shared.cleanProfile()
        ProfileImageService.shared.cleanProfileImage()
        ImagesListService.shared.cleanImagesList()
    }
    
}
