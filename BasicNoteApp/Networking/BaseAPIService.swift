//
//  BaseAPIService.swift
//  BasicNoteApp
//
//  Created by Max on 15.03.2025.
//
// (elma icin opt + shift + k) 

import Foundation


class BaseAPIService {
    static let shared = BaseAPIService() //singleton purposes
    private let apiBaseURL: String = SecretsManager.shared.getAPIKey(forKey: "API_KEY") ?? ""
    
    private init() {}
    
    // used GENERICS (<T: Decodable>) for modularity and clean code base
    func request<T: Decodable>(
            endpoint: String,
            method: String,
            body: [String: Any]? = nil, // optional
            queryParams: [String: String]? = nil, // optional again
            requiresAuth: Bool = true
    ) async throws -> T {
        
        guard !apiBaseURL.isEmpty else { throw APIError.invalidURL } // check if api is accessible from SecretsManager.swift
        
        var components = URLComponents(string: "\(apiBaseURL)\(endpoint)") // create the path
        if let queryParams = queryParams { // add query parameters if necessery
            components?.queryItems = queryParams.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        
        guard let url = components?.url else { throw APIError.invalidURL } // final form of the url, with components if there are any
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
//         auth token is optional
//         "bearer ..." is used to let api know that our auth key is a token. we add this info to the
//         http header field, which is used for auth, content type, api key etc...
        
        if requiresAuth, let token = TokenManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else if requiresAuth {
            throw APIError.unauthorized
        }
        
        // translate body to json if body exists
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        let (rawData, urlResponse) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = urlResponse as? HTTPURLResponse else { throw APIError.unknownError }
        
        switch httpResponse.statusCode {
        case 200, 201:
            //return try JSONDecoder().decode(T.self, from: rawData) // decoding for general
            let decodedResponse = try JSONDecoder().decode(T.self, from: rawData)
            return decodedResponse
        case 400:
            throw APIError.invalidCredentials
        case 403:
            throw APIError.unauthorized
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.unknownError
        }
    }
    
}

