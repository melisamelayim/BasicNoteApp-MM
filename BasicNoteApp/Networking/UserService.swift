//
//  UserService.swift
//  BasicNoteApp
//
//  Created by Max on 5.04.2025.
//

import Foundation

class UserService {
    static let shared = UserService() // singleton 
    private let authEndpoint = "users/me/"
    
    private init() {}
    
    func fetchMe() async throws -> UserResponse {
        let response: APIResponse<UserResponse> = try await BaseAPIService.shared.request(
            endpoint: authEndpoint,
            method: "GET"
        )
        
        return response.data
    }
        
    func fetchNotes(page: Int = 1) async throws -> [Note] {
        let notesEndpoint = "\(authEndpoint)notes"
        let queryParams = ["page": "\(page)"]
        
        let response: APIResponse<NotesResponse> = try await BaseAPIService.shared.request(
            endpoint: notesEndpoint,
            method: "GET",
            queryParams: queryParams
        )
        
        return response.data.data // taking notes
    }
    
    func updateUserInfo(name: String, email: String) async throws -> Bool {
        let requestBody: [String: Any] = [
            "full_name": name,
            "email": email,
        ]
        
        let _: EmptyResponse = try await BaseAPIService.shared.request(
            endpoint: authEndpoint,
            method: "PUT",
            body: requestBody
        )
        
        return true
    }
    
    func updatePassword(old: String, new: String, newRetype: String) async throws -> Bool {
        let updatePasswordEndpoint = "\(authEndpoint)password"
        let requestBody: [String: Any] = [
            "password": old,
            "new_password": new,
            "new_password_confirmation": newRetype
        ]
        
        let _: EmptyResponse = try await BaseAPIService.shared.request(
            endpoint: updatePasswordEndpoint,
            method: "PUT",
            body: requestBody
        )
        
        return true
        
//        guard let message = response.message, message == "Password has been changed." else {
//            print("olmadi ki")
//            return false
//        }
//        return true
    }

}
