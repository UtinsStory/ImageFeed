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
            print("[ProfileService: fetchProfile]: Invalid request")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastToken = token
        
        guard
            let request = makeProfileDataRequest(token: token)
        else {
            print("[ProfileService: fetchProfile]: Error while creating request")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.profile = Profile(
                    usernmane: data.username,
                    name: "\(data.firstName) \(data.lastName ?? "")",
                    loginname: "@\(data.username)",
                    bio: data.bio ?? ""
                )
                completion(.success(self.profile!))
            case .failure(let error):
                print("[ProfileService: fetchProfile]: Network error")
                completion(.failure(error))
            }
            self.task = nil
            self.lastToken = nil
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
