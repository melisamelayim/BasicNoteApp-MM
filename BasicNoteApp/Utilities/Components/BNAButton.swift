//
//  BNAButton.swift
//  BasicNoteApp
//
//  Created by Max on 19.03.2025.
//

import UIKit

class BNAButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
        
    private func setupButton() {
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .inter(.title2)
        backgroundColor = Colors.BNAPrimaryColor 
        layer.cornerRadius = 10
    }
}
