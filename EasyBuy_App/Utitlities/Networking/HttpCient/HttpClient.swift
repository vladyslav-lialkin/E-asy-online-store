//
//  HttpClient.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 05.08.2024.
//

import Foundation

class HttpClient {
    private init() {}

    static let shared = HttpClient()
    
    func fetch<T: Codable>(url: URL, mimeType: MIMEType) async throws -> [T] {
        var request = URLRequest(url: url)
        request.addValue(mimeType.rawValue,
                         forHTTPHeaderField: HttpHeaders.authorization.rawValue)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
        
        guard let objects = try? JSONDecoder().decode([T].self, from: data) else {
            throw HttpError.errorDecodingData
        }
        
        return objects
    }
    
    func sendData<T: Codable>(to url: URL, object: T, httpMethod: HttpMethod, mimeType: MIMEType) async throws {
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.addValue(mimeType.rawValue,
                             forHTTPHeaderField: HttpHeaders.authorization.rawValue)
        request.addValue(MIMEType.JSON.rawValue,
                         forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        
        request.httpBody = try? JSONEncoder().encode(object)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
        
        print(response)
    }
    
    func delete(url: URL, mimeType: MIMEType) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.DELETE.rawValue
        request.addValue(mimeType.rawValue,
                         forHTTPHeaderField: HttpHeaders.authorization.rawValue)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
    }
}
