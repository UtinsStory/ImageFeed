//
//  URLSession+data.swift
//  Image Feed
//
//  Created by Гена Утин on 31.07.2024.
//

import Foundation

enum NetworkErrors: Error {
    case httpsStatusCodeError(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async{
                completion(result)
            }
        }
        let task = dataTask(with: request) { data, response, error in
            guard let error else {
                guard let data,
                      let response,
                      let statusCode = (response as? HTTPURLResponse)?.statusCode
                else {
                    print("Network error:\(NetworkErrors.urlSessionError)")
                    return fulfillCompletionOnMainThread(
                        .failure(NetworkErrors.urlSessionError))
                }
                guard 200..<300 ~= statusCode
                else {
                    print("Network error:\(NetworkErrors.httpsStatusCodeError(statusCode))")
                    print(String(data: data, encoding: .utf8) as Any)
                    return fulfillCompletionOnMainThread(
                        .failure(NetworkErrors.httpsStatusCodeError(statusCode)))
                }
                return fulfillCompletionOnMainThread(.success(data))
            }
            print("Network error:\(NetworkErrors.urlRequestError(error))")
            fulfillCompletionOnMainThread(.failure(NetworkErrors.urlRequestError(error)))
        }
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        let task = data(for: request) { (result: Result<Data, Error>) in
            DispatchQueue.main.async {
                switch result{
                case .success(let data):
                    do {
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let resultValue = try decoder.decode(T.self, from: data)
                        completion(.success(resultValue))
                    } catch {
                        print("""
                                  Ошибка декодирование: \(error.localizedDescription)Данные: \(String(data: data, encoding: .utf8) ?? "")
                                  """)
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
}
