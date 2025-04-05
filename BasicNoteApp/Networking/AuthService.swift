//
//  AuthService.swift
//  BasicNoteApp
//
//  Created by Max on 11.03.2025.
//

import Foundation

class AuthService {
    static let shared = AuthService() //singleton purposes
    private let authEndpoint = "auth/login"
    
    private init() {}
    
    func login(withEmail email: String, password: String) async throws -> Bool {

        let requestBody: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        let response: AuthResponse = try await BaseAPIService.shared.request(
            endpoint: authEndpoint,
            method: "POST",
            body: requestBody,
            requiresAuth: false) // no need for auth at first
                
        if let token = response.data.accessToken {
            UserDefaults.standard.set(token, forKey: "auth_token")
            return true
        } else {            
            throw APIError.decodingError
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "auth_token")
    }
    
}
