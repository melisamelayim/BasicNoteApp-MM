//
//  FormValidator.swift
//  BasicNoteApp
//
//  Created by Max on 8.04.2025.
//

import Foundation

enum ValidationError: Error {
    case invalidEmail
    case invalidPassword
    case emptyField
}

struct FormValidator {
    static func emptyField(_ field: String) -> String? {
        if field.isEmpty {
            return errorMessage(for: .emptyField)
        }
        return nil
    }
    
    static func validateEmail(_ email: String) -> String? {
        if email.isEmpty {
            return errorMessage(for: .emptyField)
        }
        if !email.contains("@") || !email.contains(".") {
            return errorMessage(for: .invalidEmail)
        }
        return nil
    }
    
    static func validatePassword(_ password: String) -> String? {
        if password.isEmpty {
            return errorMessage(for: .emptyField)
        }
        if password.count < 6 {
            return errorMessage(for: .invalidPassword)
        }
        return nil
    }
    
    static func errorMessage(for error: ValidationError) -> String {
        switch error{
        case .invalidEmail:
            return "Your email address must contain '@' and '.'"
        case .invalidPassword:
            return "Password must contain at least 6 chars"
        case .emptyField:
            return "You can't leave this part empty"
        }
    }
    
}
