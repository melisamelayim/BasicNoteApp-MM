//
//  ChangePasswordViewController.swift
//  BasicNoteApp
//
//  Created by Max on 17.04.2025.
//

import UIKit

class ChangePasswordViewController: BaseViewController {
    @IBOutlet weak var oldPasswordTextField: BNAAuthTextField!
    @IBOutlet weak var newPasswordTextField: BNAAuthTextField!
    @IBOutlet weak var newPasswordRetypeTextField: BNAAuthTextField!
    
    @IBOutlet weak var oldPasswordErrorLabel: UILabel!
    @IBOutlet weak var newPasswordErrorLabel: UILabel!    
    @IBOutlet weak var newPasswordRetypeErrorLabel: UILabel!
    
    @IBOutlet weak var saveButton: BNAButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        oldPasswordTextField.placeholder = "Password"
        newPasswordTextField.placeholder = "New Password"
        newPasswordRetypeTextField.placeholder = "Retype New Password"
        
        oldPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.isSecureTextEntry = true
        newPasswordRetypeTextField.isSecureTextEntry = true
        
        self.title = "Change Password"
        
        oldPasswordErrorLabel.isHidden = true
        newPasswordErrorLabel.isHidden = true
        newPasswordRetypeErrorLabel.isHidden = true
        oldPasswordTextField.errorLabel = oldPasswordErrorLabel
        newPasswordTextField.errorLabel = newPasswordErrorLabel
        newPasswordRetypeTextField.errorLabel = newPasswordRetypeErrorLabel
        
        let buttonHeight: CGFloat = 63
        saveButton.setTitle("Save", for: .normal)
        saveButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }
    
    override func textFieldType(for textField: BNAAuthTextField) -> TextFieldType? {
        switch textField {
        case oldPasswordTextField: return .password
        case newPasswordTextField: return .password
        case newPasswordRetypeTextField: return .password
        default: return nil
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let isValid = getAllTextFields().allSatisfy { textField in
            if let error = validateTextField(textField) {
                showError(error, for: textField.errorLabel!)
                return false
            }
            return true
        }
        
        guard isValid else { return }
        
        Task {
            do {
                let isUserPasswordChanged = try await UserService.shared.updatePassword(old: oldPasswordTextField.text!, new: newPasswordTextField.text!, newRetype: newPasswordRetypeTextField.text!)
                if isUserPasswordChanged {
                    BNAToastView(
                        message: "Password updated successfully",
                        backgroundColor: Colors.BNAGreenColor
                    ).show(in: self.view)
                    
                    saveButton.setState(.inactive)
                }
            } catch {
                BNAToastView(
                    message: "You entered invalid password" ,
                    backgroundColor: Colors.BNAYellowColor
                ).show(in: self.view)
            }
        }
    }
    
    @objc override func textFieldEditingDidEnd(_ textField: UITextField) {
        super.textFieldEditingDidEnd(textField)
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        var allFieldsValid = getAllTextFields().allSatisfy { textField in
            validateTextField(textField) == nil && !(textField.text?.isEmpty ?? true)
        }
        
        if newPasswordTextField.text != newPasswordRetypeTextField.text {
            BNAToastView(
                message: "Unmatching passwords. Try again" ,
                backgroundColor: Colors.BNAErrorColor
            ).show(in: self.view)
            allFieldsValid = false
        }
        
        saveButton.setState(allFieldsValid ? .active : .inactive)
    }
    
    
    
}
