//
//  ViewController.swift
//  BasicNoteApp
//
//  Created by Max on 11.03.2025.
//


import UIKit

class NotesViewController: UIViewController, UISearchBarDelegate {
    var userSessionVM = UserSessionViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createNoteButton: BNAButton!
    
    private var searchBar: UISearchBar!
    var filteredNotes: [Note] = []
    
    var isFiltering: Bool {
        return searchBar.text?.isEmpty == false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
    }
    
    func setupUI() {
        let buttonHeight: CGFloat = 40
        
        createNoteButton.setState(.active)
        createNoteButton.setTitle(" Add Note", for: .normal)
        createNoteButton.setImage(UIImage(systemName: "plus"), for: .normal)
        createNoteButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        createNoteButton.titleLabel?.font = .inter(.title4)
        
        createNoteButton.tintColor = .white
        createNoteButton.imageView?.contentMode = .scaleAspectFit
        createNoteButton.semanticContentAttribute = .forceLeftToRight
        createNoteButton.contentHorizontalAlignment = .center
        
        searchBar = UISearchBar()
        searchBar.placeholder = "Search Notes..."
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        
        let profileButton = UIButton(type: .custom)
        profileButton.setImage(UIImage(systemName: "person"), for: .normal)
        profileButton.frame.size = CGSize(width: 50, height: 60)
        profileButton.imageView?.contentMode = .scaleAspectFit
        profileButton.tintColor = Colors.BNAPrimaryColor
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        
        let profileBarButton = UIBarButtonItem(customView: profileButton)
        navigationItem.rightBarButtonItem = profileBarButton
        
        Task {
            if TokenManager.shared.isLoggedIn {
                await userSessionVM.loadNotes()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("user couldn't log in")
            }
        }
    }
    
    
    @IBAction func createNoteButton(_ sender: BNAButton) {
        performSegue(withIdentifier: "showNoteDetail", sender: nil)
    }
    
    @objc func profileButtonTapped() {
        Task {
            await userSessionVM.loadUser()
            performSegue(withIdentifier: "showProfile", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNoteDetail",
           let detailVC = segue.destination as? NoteDetailViewController { // set up the closure to handle note updates
            detailVC.onNoteSaved = { [weak self] in
                guard let self = self else { return }
                Task {
                    await self.userSessionVM.loadNotes()
                    await MainActor.run {
                        self.tableView.reloadData()
                    }
                }
            }
            
            if let indexPath = sender as? IndexPath { // pass the note to edit (if any)
                detailVC.noteToEdit = userSessionVM.notes[indexPath.row]
            }
        }
        
        if segue.identifier == "showProfile" {
            if let profileVC = segue.destination as? ProfileViewController {
                profileVC.originalName = userSessionVM.userName
                profileVC.originalEmail = userSessionVM.userEmail
                Task {
                    await userSessionVM.loadUser()
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterNotes(for: searchText)
    }
    
    private func filterNotes(for searchText: String) {
        filteredNotes = userSessionVM.notes.filter { note in
            return note.title.lowercased().contains(searchText.lowercased()) ||
            note.note.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    }
    
}



