//
//  TokenManager.swift
//  BasicNoteApp
//
//  Created by Max on 12.04.2025.
//

import Foundation

import KeychainAccess

class TokenManager {
    static let shared = TokenManager()
    
    private let keychain = Keychain(service: "com.melisamelayim.BasicNoteApp")

    func saveToken(_ token: String) {
        keychain["access_token"] = token
    }

    func getToken() -> String? {
        return keychain["access_token"]
    }

    func clearToken() {
        try? keychain.remove("access_token")
    }

    var isLoggedIn: Bool {
        return getToken() != nil
    }
}
