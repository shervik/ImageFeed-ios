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

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .httpStatusCode(_), .urlRequestError(_), .urlSessionError:
            return "Что-то пошло не так("
        }
    }

    var failureReason: String? {
        switch self {
        case .httpStatusCode(let int):
            return "Не удалось войти в систему. Код: \(int)"
        case .urlRequestError(let error):
            return "Не удалось отправить запрос. \(error)"
        case .urlSessionError:
            return "Ошибка"
        }
    }
}

protocol NetworkRouting: AnyObject {
    func data(for: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask
}

final class NetworkService: NetworkRouting {
    let urlSession = URLSession.shared

    func makeHTTPRequest(
        baseURL: URL = AuthConfiguration.standard.defaultBaseURL,
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

    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
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
        return task
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
