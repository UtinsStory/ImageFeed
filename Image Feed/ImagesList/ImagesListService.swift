//
//  ImagesListService.swift
//  Image Feed
//
//  Created by Гена Утин on 29.08.2024.
//

import Foundation

final class ImagesListService {
    private let shared = ImagesListService()
    private init() {}
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let photosURL = "https://api.unsplash.com/photos"
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        guard task == nil else { return }

        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makePhotosRequest(page: nextPage, perPage: 10) else {
            assertionFailure("[ImagesListService: fetchPhotosNextPage]: Failed to create request")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let newPhotos)
                
            }
        }
    }
    
    func makePhotosRequest(page: Int, perPage: Int) -> URLRequest? {
        guard let baseUrl = URL(string: photosURL) else {
            assertionFailure("[ImagesListService: makePhotosRequest]: Failed to create URL")
            return nil
        }
        guard let token = OAuth2TokenStorage.shared.token else { return nil }
        
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
                
                let queryItems = [
                    URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "per_page", value: "\(perPage)")
                ]
        urlComponents?.queryItems = queryItems
                
                guard let url = urlComponents?.url else { return nil }
                
                var request = URLRequest(url: url)
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.httpMethod = "GET"
                
                return request
        
    }
    
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
