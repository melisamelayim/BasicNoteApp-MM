//
//  AuthService.swift
//  BasicNoteApp
//
//  Created by Max on 11.03.2025.
//

import Foundation

class AuthService {
    static let shared = AuthService() //singleton purposes
    private let authEndpoint = "auth/"
    
    private init() {}
    
    func login(withEmail email: String, password: String) async throws -> Bool {
        let requestBody: [String: Any] = [
            "email": email,
            "password": password
        ]
        let response: AuthResponse = try await BaseAPIService.shared.request(
            endpoint: "\(authEndpoint)login",
            method: "POST",
            body: requestBody,
            requiresAuth: false) // no need for auth at first
                   
        if let token = response.data?.accessToken {
            TokenManager.shared.saveToken(token)
            return true
        } else {
            throw APIError.invalidCredentials            
        }
    }
    
    func register(fullName name: String, withEmail email: String, password: String) async throws -> Bool {
        let requestBody: [String: Any] = [
            "full_name": name,
            "email": email,
            "password": password
        ]
                
        let response: AuthResponse = try await BaseAPIService.shared.request(
            endpoint: "\(authEndpoint)register",
            method: "POST",
            body: requestBody,
            requiresAuth: false) // no need for auth at first
                        
        if let token = response.data?.accessToken {
            TokenManager.shared.saveToken(token)
            return true
        } else {
            throw APIError.decodingError
        }
    }
    
    func resetPassword(withEmail email: String) async throws -> Bool {
        let requestBody: [String: Any] = [
            "email": email,
        ]
        let response: AuthResponse = try await BaseAPIService.shared.request(
            endpoint: "\(authEndpoint)forgot-password",
            method: "POST",
            body: requestBody,
            requiresAuth: false) // no need for auth at first
                
        guard let code = response.code, code == "auth.forgot-password" else {
            return false
        }
        return true
    }

    func logout() {
        TokenManager.shared.clearToken()
    }
    
}
