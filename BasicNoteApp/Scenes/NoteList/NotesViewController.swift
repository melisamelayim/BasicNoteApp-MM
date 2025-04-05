//
//  ViewController.swift
//  BasicNoteApp
//
//  Created by Max on 11.03.2025.
//


import UIKit

class NotesViewController: UIViewController {
    var userSessionViewModel = UserSessionViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createNoteButton: BNAButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        createNoteButton.setTitle("Create Note", for: .normal)
        
        Task {
            await userSessionViewModel.authenticateUser(email:"melisamelayim@gmail.com", password:"123456") // token is saved
            
            if userSessionViewModel.isAuthenticated { // if token's successful:
                await userSessionViewModel.loadNotes()
                tableView.reloadData()
            } else {
                print("user couldn't log in")
            }
        }
    }
    
    
    @IBAction func createNoteButton(_ sender: BNAButton) {
        performSegue(withIdentifier: "showNoteDetail", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNoteDetail",
           let detailVC = segue.destination as? NoteDetailViewController {
            
            // Set up the closure to handle note updates
            detailVC.onNoteSaved = { [weak self] in
                guard let self = self else { return }
                Task {
                    await self.userSessionViewModel.loadNotes()
                    await MainActor.run {
                        self.tableView.reloadData()
                    }
                }
            }
            
            // Pass the note to edit (if any)
            if let indexPath = sender as? IndexPath {
                detailVC.noteToEdit = userSessionViewModel.notes[indexPath.row]
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    
    @objc func reloadTableView() {
        Task {
            do {
                let fetchedNotes = try await UserService.shared.fetchNotes()
                DispatchQueue.main.async {
                    self.userSessionViewModel.notes = fetchedNotes
                    self.tableView.reloadData()
                }
            } catch {
                print("couldn't reload notes :( \(error)")
            }
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    }
}


