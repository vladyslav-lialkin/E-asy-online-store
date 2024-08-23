//
//  HttpMethod.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 05.08.2024.
//

import Foundation

enum HttpMethod: String {
    case POST, GET, PATCH, DELETE
}

enum MIMEType: String {
    case JSON = "application/json"
}

enum HttpHeaders: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum HttpError: Error {
    case badURL, badResponse, errorDecodingData, invalidURL, tokenDontSave
}
