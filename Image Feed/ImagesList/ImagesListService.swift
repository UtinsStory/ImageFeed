//
//  ImagesListService.swift
//  Image Feed
//
//  Created by Гена Утин on 29.08.2024.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
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
            case .success(let newPhotos):
                addPhotos(newPhotos: newPhotos)
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification,
                                                object: self)
            case .failure:
                print("[ImagesListService: fetchPhotosNextPage]: Failed to fetch photos")
            }
            self.task = nil
            self.lastLoadedPage = nextPage
        }
        self.task = task
        task.resume()
    }
    
    func makePhotosRequest(page: Int, perPage: Int) -> URLRequest? {
        guard let baseURL = URL(string: "https://api.unsplash.com") else { return nil }
        guard let token = OAuth2TokenStorage.shared.token else { return nil }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.path = "/photos"
        
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        components?.queryItems = queryItems
        
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
        
    }
    
    func addPhotos(newPhotos: [PhotoResult]) {
        let dateFormatter = ISO8601DateFormatter()
        
        for photo in newPhotos {
            let newPhoto = Photo(id: photo.id,
                                 size: CGSize(width: photo.width, height: photo.height),
                                 createdAt: dateFormatter.date(from: photo.createdAt ?? ""),
                                 welcomeDescription: photo.description,
                                 thumbImageURL: photo.urls.thumb,
                                 largeImageURL: photo.urls.full,
                                 isLiked: photo.likedByUser)
            photos.append(newPhoto)
        }
    }
    
    func changeLike(photoId: String, 
                    isLike: Bool,
                    _ completion: @escaping (Result<Void?, Error>) -> Void) {
        
//        let baseURL = "https://api.unsplash.com"
        guard let token = OAuth2TokenStorage.shared.token else {return}
        guard let url = URL(string: "/photos/\(photoId)/like", relativeTo: Constants.defaultBaseURL) else {return}
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = isLike ? "DELETE" : "POST"
        
        urlSession.objectTask(for: request) { [weak self] (result: Result<LikedPhoto, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    self.photos[index].isLiked = response.photo.likedByUser
                    completion(.success(nil))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }.resume()
    }
    
    func cleanImagesList() {
        photos = []
        task?.cancel()
        lastLoadedPage = 1
    }
    
}

struct Photo {
    let id: String
    let size: CGSize
    var createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}
