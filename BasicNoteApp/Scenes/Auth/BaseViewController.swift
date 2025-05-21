//
//  BaseViewController.swift
//  BasicNoteApp
//
//  Created by Max on 11.04.2025.
//

import UIKit

// base vc for login, register, forgot password and profile views
class BaseViewController: UIViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
    }
    
    func setupTextFields() {
        let textFields = getAllTextFields()
        textFields.forEach { textField in
            textField.delegate = self
            textField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
            textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)            
        }
    }
    
    enum TextFieldType {
        case fullName
        case email
        case password
    }
    
    func validateTextField(_ textField: BNAAuthTextField) -> String? {
        guard let type = textFieldType(for: textField) else { return nil }
        
        switch type {
        case .fullName:
            return FormValidator.emptyField(textField.text ?? "")
        case .email:
            return FormValidator.validateEmail(textField.text ?? "")
        case .password:
            return FormValidator.validatePassword(textField.text ?? "")
        }
    }
    
    func textFieldType(for textField: BNAAuthTextField) -> TextFieldType? {
        fatalError("problem")
    }
    
    // returns every subview that's compatible with type BNAAuthTextField
    func getAllTextFields() -> [BNAAuthTextField] {
        var results = [BNAAuthTextField]()
        for subview in view.subviews {
            results += subview.subviews.compactMap { $0 as? BNAAuthTextField }
        }
        return results
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldEditingDidEnd(textField)        
        return true
    }
    
    @objc func textFieldEditingDidBegin(_ textField: UITextField) {
        guard let textField = textField as? BNAAuthTextField else { return }
        textField.layer.borderColor = Colors.BNAPrimaryColor.cgColor
        hideError(for: textField.errorLabel!)
        textField.hideErrorUI()
    }
    
    @objc func textFieldEditingDidEnd(_ textField: UITextField) {
        guard let textField = textField as? BNAAuthTextField else { return }
        if let error = validateTextField(textField) {
            showError(error, for: textField.errorLabel!)
            textField.showErrorUI()
        } else {
            hideError(for: textField.errorLabel!)
            textField.hideErrorUI()
        }
    }
    
    // for real time validation
    
    
    func showError(_ message: String, for label: UILabel) {
        label.attributedText = TextIconAdder.iconText(iconName: "exclamationmark.triangle", text: message, iconColor: Colors.BNAErrorColor)
        
        if label.isHidden {
            label.isHidden = false
            label.font = UIFont.inter(.title5)
            label.textColor = Colors.BNAErrorColor
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    func hideError(for label: UILabel) {
        if !label.isHidden {
            label.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

}
