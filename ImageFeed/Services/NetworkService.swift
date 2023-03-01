//
//  NetworkService.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 20.02.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

protocol NetworkRouting {
    func data(for: URLRequest, completion: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkService: NetworkRouting {
    private let urlSession = URLSession.shared

    func makeHTTPRequest(
        baseURL: URL = defaultBaseURL,
        path: String,
        httpMethod: String,
        query: [URLQueryItem]?) -> URLRequest {
            var component = URLComponents()
            component.path = path
            component.queryItems = query
            guard let url = component.url(relativeTo: baseURL) else { fatalError() }

            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            return request
        }

    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let handler: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        let task = urlSession.dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    handler(.success(data))
                } else {
                    handler(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                handler(.failure(NetworkError.urlRequestError(error)))
            } else {
                handler(.failure(NetworkError.urlSessionError))
            }
        }

        task.resume()
    }

    func decodeJson<T: Decodable>(type: T.Type, data: Data?) -> T? {
        guard let data = data else { return nil }

        do {
            return try JSONDecoder().decode(type, from: data)
        } catch let error {
            print("Couldn't decode data into \(error)")
            return nil
        }
    }
}
