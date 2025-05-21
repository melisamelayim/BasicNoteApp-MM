//
//  UserSessionViewModel.swift
//  BasicNoteApp
//
//  Created by Max on 15.03.2025.
//

import Foundation

// what does observableobject mean? well, it means WHEN this class is triggered somehow (changes inside happen),
// the view will be updated. view is listening to this class, that's what it means


// updates main thread about authenticating and logging out (for note and notes detail vc's)
class UserSessionViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
        
    func loadNotes() async {
        do {
            let fetchedNotes = try await UserService.shared.fetchNotes()
            updateMainThread {
                self.notes = fetchedNotes
            }
        } catch {
            print("\(APIError.decodingError)")
        }
    }
    
    func loadUser() async {
        do {
            let fetchedUser = try await UserService.shared.fetchMe()
            
            updateMainThread {
                self.userName = fetchedUser.fullName
                self.userEmail = fetchedUser.email
            }
        } catch {
            print("\(APIError.decodingError)")
        }
    }    
    
    private func updateMainThread(_ action: @escaping () -> Void) {
        DispatchQueue.main.async {
            action()
        }
    }
    
}
