//
//  BNAAuthTextField.swift
//  BasicNoteApp
//
//  Created by Max on 19.03.2025.
//

import UIKit

class BNAAuthTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupField()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupField()
    }
        
    private func setupField() {
        tintColor = Colors.BNAPrimaryColor
        textColor = Colors.BNAGrayDark
        font = UIFont(name: Fonts.interMedium, size: Titles.title2.pointSize) ?? Titles.title2
        autocorrectionType = .no
        clipsToBounds = true
        
        let placeholder = self.placeholder != nil ? self.placeholder! : ""
        let placeholderFont = UIFont(name: Fonts.interMedium, size: Titles.title3.pointSize) ?? Titles.title3
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: [NSAttributedString.Key.foregroundColor: Colors.BNAGrayLight,
                                                                NSAttributedString.Key.font: placeholderFont])
        
    }

}
