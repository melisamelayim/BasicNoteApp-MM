//
//  NoteCell.swift
//  BasicNoteApp
//
//  Created by Max on 11.03.2025.
//

import UIKit

class NoteCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(with note: Note) {
        titleLabel.text = note.title
        descriptionLabel.text = note.note
        
        titleLabel.font = .inter(.title2)
        
        descriptionLabel.font = .inter(.title3)
        descriptionLabel.textColor = Colors.BNAGrayDark

    }
    
}
