//
//  PhotoResult.swift
//  Image Feed
//
//  Created by Гена Утин on 29.08.2024.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let urls: UrlsResult
    let description: String?
    var likedByUser: Bool
}

struct LikedPhoto: Codable {
    let photo: PhotoResult
}
