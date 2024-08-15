//
//  OAuthTokenResponseBody.swift
//  Image Feed
//
//  Created by Гена Утин on 31.07.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let acccessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
}
