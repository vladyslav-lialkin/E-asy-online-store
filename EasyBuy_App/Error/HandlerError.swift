//
//  ErrorHandle.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 23.08.2024.
//

import SwiftUI

struct HandlerError {
    private init() {}
    
    static func httpError(_ error: HttpError) -> LocalizedStringKey {
        switch error {
        case .badURL:
            print("The URL provided is invalid.")
        case .badToken:
            print("The token is not available.")
            return "Re-enter the autorization."
        case .badResponse:
            print("Received a bad response from the server.")
        case .errorDecodingData:
            print("Failed to decode the data.")
        case .invalidURL:
            print("The URL is invalid.")
        case .tokenDontSave:
            print("The token was not saved property.")
            return "Authorization error"
        }
        
        return "server_connection_issue"
    }
}
