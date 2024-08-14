//
//  OAuth2Service.swift
//  Image Feed
//
//  Created by Гена Утин on 30.07.2024.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    //MARK: - Methods
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
//        guard let url = URL(string: "...\(code)") else {
//            assertionFailure("Failed to create URL")
//            return nil
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        return request
    }
    
    func fetchOAuthToken(
        withCode code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.data(for: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                        let token = response.token
                        completion(.success(token))
                    } catch {
                        print("Authorization token decode error: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
                self.task = nil
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}
//        let request = makeOAuthTokenRequest(code: code)
//        guard let request else {
//            print("Invalid fetch token request")
//            return
//        }
//
//        let task = URLSession.shared.data(for: request) { result in
//            switch result {
//            case .success(let data):
//                do {
//                    let decoder = JSONDecoder()
//                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
//                    let token = response.token
//                    completion(.success(token))
//                } catch {
//                    print("Authorization toke decode error: \(error.localizedDescription)")
//                    completion(.failure(error))
//                }
//
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//        task.resume()

