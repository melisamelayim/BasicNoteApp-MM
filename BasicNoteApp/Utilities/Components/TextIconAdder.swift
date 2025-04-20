//
//  TextIconAdder.swift
//  BasicNoteApp
//
//  Created by Max on 14.04.2025.
//

import Foundation
import UIKit

class TextIconAdder {
    static func iconText(iconName: String, text: String, iconColor: UIColor) -> NSAttributedString {
        let icon = NSTextAttachment()
        icon.image = UIImage(systemName: iconName)?.withTintColor(iconColor)
        let result = NSMutableAttributedString(attachment: icon)
        result.append(NSAttributedString(string: " " + text))
        return result
    }
}
