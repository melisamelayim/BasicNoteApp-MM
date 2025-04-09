//
//  UserSessionViewModel.swift
//  BasicNoteApp
//
//  Created by Max on 15.03.2025.
//

import Foundation

// what does observableobject mean? well, it means WHEN this class is triggered somehow (changes inside happen),
// the view will be updated. view is listening to this class, that's what it means


// updates main thread about authenticating and logging out
class UserSessionViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var errorMessage: String? = nil
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    
    var onNotesUpdated: (() -> Void)?
    
    func authenticateUser(email: String, password: String) async {
        isLoading = true
        
        do {
            let success = try await AuthService.shared.login(withEmail: email, password: password) 
            
            updateMainThread {
                self.isAuthenticated = success
                if !success {
                    print("login failed. check your email or password")
                }
            }
        } catch {
            print("\(APIError.unknownError)")
        }
        isLoading = false
    }
    
    
    func loadNotes() async {
        do {
            let fetchedNotes = try await UserService.shared.fetchNotes()
            
            updateMainThread {
                self.notes = fetchedNotes
                self.onNotesUpdated?()
            }
        } catch {
            print("\(APIError.decodingError)")
        }
    }
        
    
    func logout() {
            AuthService.shared.logout()
            updateMainThread {
                self.isAuthenticated = false
                self.notes = []
            }
        }
    
    
    private func updateMainThread(_ action: @escaping () -> Void) {
        DispatchQueue.main.async {
            action()
        }
    }
    
}
