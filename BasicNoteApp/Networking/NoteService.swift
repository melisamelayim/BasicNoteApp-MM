//
//  NoteService.swift
//  BasicNoteApp
//
//  Created by Max on 13.03.2025.
//

import Foundation

class NoteService {
    static let shared = NoteService() // singleton
    private init() {}
    
    func getNoteFromId(noteId: Int) async throws -> Note {
        let endpoint = "notes/\(noteId)"
        let response: APIResponse<Note> = try await BaseAPIService.shared.request(
            endpoint: endpoint,
            method: "GET"
        )
        return response.data
    }
    
    func createNote(title: String, content: String) async throws -> Note {
        let requestBody: [String: Any] = ["title": title, "note": content]
        let response: APIResponse<Note> = try await BaseAPIService.shared.request(
            endpoint: "notes",
            method: "POST",
            body: requestBody
        )
        return response.data
    }
    
    func updateNote(noteId: Int, newTitle: String, newContent: String) async throws {
        let requestBody: [String: Any] = ["title": newTitle, "note": newContent]
        let _: EmptyResponse = try await BaseAPIService.shared.request(
            endpoint: "notes/\(noteId)",
            method: "PUT",
            body: requestBody
        )
    }
    
    func deleteNote(noteId: Int) async throws {
        let _: EmptyResponse = try await BaseAPIService.shared.request(endpoint: "notes/\(noteId)", method: "DELETE")
    }
    
}



