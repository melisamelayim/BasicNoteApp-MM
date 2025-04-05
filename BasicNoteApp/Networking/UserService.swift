//
//  UserService.swift
//  BasicNoteApp
//
//  Created by Max on 5.04.2025.
//

import Foundation

class UserService {
    static let shared = UserService() // singleton 
    private init() {}    
    
    func fetchNotes(page: Int = 1) async throws -> [Note] {
        let notesEndpoint = "users/me/notes"
        let queryParams = ["page": "\(page)"]
        
        let response: APIResponse<NotesResponse> = try await BaseAPIService.shared.request(
            endpoint: notesEndpoint,
            method: "GET",
            queryParams: queryParams
        )
        
        return response.data.data // taking notes
    }
    
}
