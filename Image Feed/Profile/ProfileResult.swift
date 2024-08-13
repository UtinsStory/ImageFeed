//
//  ProfileResult.swift
//  Image Feed
//
//  Created by Гена Утин on 12.08.2024.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastname: String?
    let bio: String?
    
}

private enum CodingKeys: String, CodingKey {
    case firstname = "first_name"
    case lastname = "last_name"
}

struct Profile {
    let usernmane: String
    let name: String
    let loginname: String
    let bio: String
}
