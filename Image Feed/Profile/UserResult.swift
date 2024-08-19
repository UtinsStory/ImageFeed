//
//  UserResult.swift
//  Image Feed
//
//  Created by Гена Утин on 15.08.2024.
//

import Foundation

struct UserResult: Codable {
    let profileImage: UserImage
}

struct UserImage: Codable {
    let small: String
    let medium: String
    let large: String
}
