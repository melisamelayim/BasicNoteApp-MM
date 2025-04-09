//
//  Note.swift
//  BasicNoteApp
//
//  Created by Max on 13.03.2025.
//

import Foundation

struct Note: Codable {
    let id: Int
    let title: String
    let note: String
}

struct APIResponse<T: Decodable>: Decodable {
    let code: String
    let data: T
}

struct NotesResponse: Decodable {
    let current_page: Int
    let data: [Note]
}
