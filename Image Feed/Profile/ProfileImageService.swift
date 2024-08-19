//
//  ProfileImageService.swift
//  Image Feed
//
//  Created by Гена Утин on 15.08.2024.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    private(set) var avatarURL: String?
    private var task: URLSessionTask?
    private var urlSession = URLSession.shared
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private func makeProfileImageRequest(token: String, userName: String) -> URLRequest? {
        guard let url = URL(string: "/users/\(userName)", relativeTo: Constants.defaultBaseURL)
        else {
            assertionFailure("[ProfileImageService: makeProfileImageRequest]: Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
    
    func fetchProfileImageURL(username: String, token: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard task == nil else {
            print("[ProfileImageService: fetchProfileImageURL]: Invalid request")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let request = makeProfileImageRequest(token: token, userName: username)
        guard let request else {
            print("[ProfileImageService: fetchProfileImageURL]: Error while creating the request")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let data):
                        let profileImageURL = data.profileImage.medium
                        self.avatarURL = profileImageURL
                        NotificationCenter.default.post(
                            name: ProfileImageService.didChangeNotification,
                            object: self
                        )
                        completion(.success(profileImageURL))
                    case .failure(let error):
                        print("[ProfileImageService: fetchProfileImageURL]: Error while fethicng the profile image")
                        completion(.failure(error))
                    }
                    self.task = nil
                }
                self.task = task
                task.resume()
            }
}
