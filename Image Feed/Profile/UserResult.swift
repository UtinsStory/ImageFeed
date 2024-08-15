//
//  UserResult.swift
//  Image Feed
//
//  Created by Гена Утин on 15.08.2024.
//

import Foundation

struct UserResult: Codable {
    let profileImage: UserImage
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct UserImage: Codable {
    let small: String
}
