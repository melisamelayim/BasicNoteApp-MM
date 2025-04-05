//
//  APIError.swift
//  BasicNoteApp
//
//  Created by Max on 13.03.2025.
//

import Foundation

enum APIError:  Error {
    case invalidURL
    case unauthorized
    case badRequest
    case serverError
    case decodingError
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "invalid URL"
        case .unauthorized:
            return "authorization error, please log in"
        case .badRequest:
            return "bad request, please check connection"
        case .serverError:
            return "server error, please try again later"
        case .decodingError:
            return "decoding error"
        case .unknownError:
            return "unknown error occured"
        }
    }
    
}
