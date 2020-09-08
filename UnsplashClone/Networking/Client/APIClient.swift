//
//  APIClient.swift
//  UnsplashClone
//
//  Created by Khoa Pham on 9/7/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum ServiceError: Error {
    case noInternetConnection
    case custom(String)
    case other
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No Internet connection"
        case .other:
            return "Something went wrong"
        case .custom(let message):
            return message
        }
    }
}

extension ServiceError {
    init(json: JSON) {
        if let message =  json["errors"] as? [String] {
            self = .custom(message.joined(separator: " - "))
        } else {
            self = .other
        }
    }
}

extension URL {
    init(baseUrl: String, path: String, params: JSON, method: HTTPMethod) {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        
        switch method {
        case .get:
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        default:
            break
        }
        
        self = components.url!
    }
}

extension URLRequest {
    init(baseUrl: String, path: String, method: HTTPMethod, params: JSON) {
        let url = URL(baseUrl: baseUrl, path: path, params: params, method: method)
        self.init(url: url)
        httpMethod = method.rawValue
        setValue("application/json", forHTTPHeaderField: "Accept")
        setValue("application/json", forHTTPHeaderField: "Content-Type")
        setValue("v1", forHTTPHeaderField: "Accept-Version")
        setValue("Client-ID vb6qpJpe9v-DL4Kb-mp4Y-Rhz5PoCbttvnOPZuYl2sc", forHTTPHeaderField: "Authorization")
        switch method {
        case .post:
            httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        default:
            break
        }
    }
}

final class APIClient {
    private let baseUrl: String
    
    init() {
        self.baseUrl = "https://api.unsplash.com"
    }
    
    func load(path: String, method: HTTPMethod, params: JSON, completion: @escaping (Data?, ServiceError?) -> ()) -> URLSessionDataTask? {
        
        // Adding common parameters
//        var parameters = params

        // Creating the URLRequest object
        let request = URLRequest(baseUrl: baseUrl, path: path, method: method, params: params)

        // Sending request to the server.
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
                completion(data, nil)
            } else {
                let error: ServiceError = .custom(error?.localizedDescription ?? "")
                completion(nil, error)
            }
        }
        
        task.resume()
        
        return task
    }
}
