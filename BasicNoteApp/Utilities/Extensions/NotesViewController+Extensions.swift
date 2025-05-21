//
//  ViewController+Extensions.swift
//  BasicNoteApp
//
//  Created by Max on 15.03.2025.
//

import Foundation
import UIKit

// notice: the moment you use "extension ViewController", swift understands that "ViewController" adn this file are related
// and can use the same properties

extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredNotes.count : userSessionVM.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteCell else {
            return UITableViewCell()
        }
        let note = isFiltering ? filteredNotes[indexPath.row] : userSessionVM.notes[indexPath.row]
        
        cell.configure(with: note)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let note = isFiltering ? filteredNotes[indexPath.row] : userSessionVM.notes[indexPath.row]
        
        // delete
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in
            let alert = UIAlertController(title: "Delete Note", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                Task {
                    do {
                        try await NoteService.shared.deleteNote(noteId: note.id)
                        self.userSessionVM.notes.remove(at: indexPath.row)
                        
                        await MainActor.run {
                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                        completionHandler(true)
                    } catch {
                        print("delete error: \(error)")
                        completionHandler(false)
                    }
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = Colors.BNAErrorColor
        
        // edit
        let editAction = UIContextualAction(style: .normal, title: "") { (_, _, completionHandler) in
            self.performSegue(withIdentifier: "showNoteDetail", sender: indexPath)
            completionHandler(true)
        }
        
        editAction.backgroundColor = Colors.BNAYellowColor
        editAction.image = UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
        
}


