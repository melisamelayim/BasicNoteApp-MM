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

struct NotesResponse: Codable {
    let current_page: Int
    let data: [Note]
}

struct UserResponse: Codable {
    let id: Int
    let fullName: String
    let email: String
 
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
    }
}
