//
//  ProfileService.swift
//  Image Feed
//
//  Created by Гена Утин on 12.08.2024.
//

import Foundation

final class ProfileService {
    
    
    static let shared = ProfileService()
    private init() {}
    
    private(set) var profile: Profile?
    
    private let urlSession = URLSession.shared
    private let profileURL = "https://api.unsplash.com/me"
    private var task: URLSessionTask?
    private var lastToken: String?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastToken != token else {
            print("Invalid request")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastToken = token
        
        guard let request = makeProfileDataRequest(token: token) else {
            print("Error while creating the request")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        let task = urlSession.data(for: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(ProfileResult.self, from: data)
                        self.profile = Profile(usernmane: response.username,
                                               name: "\(response.firstName)\(response.lastname ?? "")",
                                               loginname: "@\(response.username)",
                                               bio: response.bio ?? "")
                        completion(.success(self.profile!))
                    } catch {
                        print("Profile data decode error: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
                self.task = nil
                self.lastToken = nil
            }
        }
            self.task = task
            task.resume()

    }
    
    private func makeProfileDataRequest(token: String) -> URLRequest? {
        guard let url = URL(string: profileURL) else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
    
    
}
