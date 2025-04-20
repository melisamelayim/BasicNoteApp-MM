//
//  BNAAuthTextField.swift
//  BasicNoteApp
//
//  Created by Max on 19.03.2025.
//

import UIKit

class BNAAuthTextField: UITextField {
    private let textFieldHeight: CGFloat = 53
    
    var errorLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupField()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupField()
    }
        
    private func setupField() {
        textColor = Colors.BNABlack
        font = UIFont.inter(.title2)
        autocorrectionType = .no
        clipsToBounds = false
        layer.cornerRadius = 5
        layer.borderWidth = 1.5
        layer.borderColor = Colors.BNAGrayLight.cgColor
        
        self.returnKeyType = .done

        let placeholder = self.placeholder != nil ? self.placeholder! : ""
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: [
                                                    .foregroundColor: Colors.BNAGrayLight,
                                                    .font: UIFont.inter(.title2)
                                                   ]
        )
        
        heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
    }
    
    func showErrorUI() {
        layer.borderColor = Colors.BNAErrorColor.cgColor
        
    }
    
    func hideErrorUI() {
        layer.borderColor = isEditing ? Colors.BNAPrimaryColor.cgColor : Colors.BNAGrayLight.cgColor
    }

}
