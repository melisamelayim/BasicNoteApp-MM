//
//  AuthResponse.swift
//  BasicNoteApp
//
//  Created by Max on 15.03.2025.
//

import Foundation

struct AuthResponse: Codable {
    let code: String?
    let data: TokenData?
    
    struct TokenData: Codable {
        let accessToken: String?
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
        }
    }
}

// instead of using JSONSerialization.jsonObject everytime, we use Codable which is more natural for swift
// and we got rid of unnecessary string manipulations
