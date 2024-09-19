//
//  HttpClient.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 05.08.2024.
//

import Foundation

struct HttpClient {
    private init() {}

    static let shared = HttpClient()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        return URLSession(configuration: config)
    }()
    
    func fetch<T: Codable>(url: URL, token: String) async throws -> T {
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)",
                         forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw HttpError.badResponse
        }
        
        guard let objects = try? JSONDecoder().decode(T.self, from: data) else {
            throw HttpError.errorDecodingData
        }
        
        return objects
    }
    
    func fetch(url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw HttpError.badResponse
        }
        
        return data
    }
        
    func sendData<T: Codable>(to url: URL, object: T, httpMethod: HttpMethod, token: String) async throws {
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.addValue("Bearer \(token)",
                         forHTTPHeaderField: "Authorization")
        request.addValue(MIMEType.JSON.rawValue,
                         forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        
        request.httpBody = try JSONEncoder().encode(object)
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw HttpError.badResponse
        }
    }
    
    func delete(url: URL, token: String) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.DELETE.rawValue
        request.addValue("Bearer \(token)",
                         forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw HttpError.badResponse
        }
    }
}
