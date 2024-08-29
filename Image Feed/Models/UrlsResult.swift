//
//  UrlsResult.swift
//  Image Feed
//
//  Created by Гена Утин on 29.08.2024.
//

import Foundation

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
