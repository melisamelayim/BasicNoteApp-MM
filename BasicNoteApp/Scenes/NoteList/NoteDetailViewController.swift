//
//  NoteDetailViewController.swift
//  BasicNoteApp
//
//  Created by Max on 21.03.2025.
//

import UIKit

class NoteDetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var saveButton: BNAButton!
    
    var onNoteSaved: (() -> Void)?
    
    var noteToEdit: Note? // if exists, we're in edit mode
    private var originalTitle: String = ""
    private var originalContent: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let note = noteToEdit {
            editingNoteFirst(note: note)
        } else {
            newNoteCreatedFirst()
        }
        
        setupListeners()
    }
    
    private func newNoteCreatedFirst() {
        titleTextField.text = ""
        contentTextView.text = ""
        originalTitle = ""
        originalContent = ""
        saveButton.setTitle("Save Note", for: .normal)
        self.title = "New Note"
    }
    
    private func editingNoteFirst(note: Note) {
        titleTextField.text = note.title
        contentTextView.text = note.note
        originalTitle = note.title
        originalContent = note.note
        saveButton.setTitle("Update Note", for: .normal)
        self.title = "Edit Note"
    }
    
    private func setupListeners() {
        titleTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        contentTextView.delegate = self
    }
    
    @objc private func textFieldsDidChange() {
        checkIfNoteChanged()
    }
    
    private func checkIfNoteChanged() {
        let isTitleChanged = titleTextField.text != originalTitle
        let isContentChanged = contentTextView.text != originalContent
        saveButton.isEnabled = isTitleChanged || isContentChanged
        
        saveButton.alpha = saveButton.isEnabled ? 1.0 : 0.5
    }
    
    
    @IBAction func saveButtonTapped(_ sender: BNAButton) {
        guard let titleX = titleTextField.text, !titleX.isEmpty,
              let contentX = contentTextView.text, !contentX.isEmpty else {
            print("can't leave title or content empty")
            return
        }
        
        
        
        Task {
            if let existingNote = noteToEdit {
                await editingNote(existingNote: existingNote, title: titleX, content: contentX)
                saveButton.setTitle("Update Note", for: .normal)
                self.title = "Edit Note"
                
            } else {
                do {
                    let newNote = try await newNoteCreated(title: titleX, content: contentX)
                    self.noteToEdit = newNote  // ❗️Artık update moduna geçiyoruz
                    self.originalTitle = titleX
                    self.originalContent = contentX
                    
                    await MainActor.run {
                        saveButton.setTitle("Update Note", for: .normal)
                        self.title = "Edit Note"
                        onNoteSaved?()
                    }
                    
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            saveButton.isEnabled = false
            saveButton.alpha = 0.5
        }
        
        
    }
    
    private func editingNote(existingNote: Note, title: String, content: String) async {
        do {
            try await NoteService.shared.updateNote(
                noteId: existingNote.id,
                newTitle: title,
                newContent: content
            )
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        print("note updated")
        await MainActor.run {
            onNoteSaved?()
        }
        
        originalTitle = title
        originalContent = content
        
        checkIfNoteChanged()
    }
    
    
    private func newNoteCreated(title: String, content: String) async throws -> Note {
        do {
            let returnedNote = try await NoteService.shared.createNote(title: title, content: content)
            print("note created")
            await MainActor.run {
                onNoteSaved?()
            }
            return returnedNote
        } catch {
            print("error: \(error.localizedDescription)")
            throw error // burası eksikti!
        }
    }
    
    
}

extension NoteDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkIfNoteChanged()
    }
}
