//
//  BNAButton.swift
//  BasicNoteApp
//
//  Created by Max on 19.03.2025.
//

import UIKit

class BNAButton: UIButton {
    enum ButtonState {
        case active
        case inactive
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setState(.inactive)
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
        setState(.inactive)
    }
        
    private func setupButton() {
        titleLabel?.font = .inter(.title2)
        layer.cornerRadius = 5
        backgroundColor = Colors.BNAPrimaryColorLight
        setTitleColor(.gray, for: .normal)
    }
    
    func setState(_ state: ButtonState) {
        switch state {
        case .active:
            backgroundColor = Colors.BNAPrimaryColor
            setTitleColor(.white, for: .normal)
            isEnabled = true
        case .inactive:
            backgroundColor = Colors.BNAPrimaryColorLight
            setTitleColor(Colors.BNAGrayDark, for: .normal)
            isEnabled = false
        }
    }
    
    
}
