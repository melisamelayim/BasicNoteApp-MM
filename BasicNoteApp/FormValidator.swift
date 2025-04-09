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
    static func emptyField(_ field: String) -> ValidationError? {
        if field.isEmpty {
            return .emptyField
        }
        return nil
    }
    
    static func validateEmail(_ email: String) -> ValidationError? {
        if email.isEmpty {
            return .emptyField
        }
        if !email.contains("@") || !email.contains(".") {
            return .invalidEmail
        }
        return nil
    }
    
    static func validatePassword(_ password: String) -> ValidationError? {
        if password.isEmpty {
            return .emptyField
        }
        if password.count < 8 {
            return .invalidPassword
        }
        return nil
    }
    
    static func errorMessage(for error: ValidationError) -> String {
        switch error{
        case .invalidEmail:
            return "Your email address must contain '@' and '.'"
        case .invalidPassword:
            return "Password Invalid"
        case .emptyField:
            return "You can't leave this part empty"
        }
    }
    
}
