//
//  OAuthTokenResponseBody.swift
//  Image Feed
//
//  Created by Гена Утин on 31.07.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let token: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    private enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
        case createdAt = "created_at"
    }
}