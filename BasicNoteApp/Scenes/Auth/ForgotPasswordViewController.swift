//
//  ForgotPasswordViewController.swift
//  BasicNoteApp
//
//  Created by Max on 11.04.2025.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var forgotPasswordSecondaryLabel: UILabel!
    
    @IBOutlet weak var emailTextField: BNAAuthTextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    @IBOutlet weak var resetPasswordButton: BNAButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextFields()
    }
    
    func setupUI() {
        forgotPasswordLabel.font = .inter(.title1)
        forgotPasswordSecondaryLabel.font = .inter(.title3)
        forgotPasswordSecondaryLabel.textColor = Colors.BNAGrayDark
        
        emailTextField.placeholder = "Email Address"
        
        let buttonHeight: CGFloat = 63
        resetPasswordButton.setTitle("Reset Password", for: .normal)
        resetPasswordButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        emailErrorLabel.isHidden = true
        emailTextField.errorLabel = emailErrorLabel
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: BNAButton) {
        let isValid: Bool
        if let error = FormValidator.validateEmail(emailTextField.text!) {
            showError(error, for: emailTextField.errorLabel!)
            isValid = false
        } else {
            isValid = true
        }
        guard isValid else { return }

        Task {
            do {
                let resetRequest = try await AuthService.shared.resetPassword(withEmail: emailTextField.text!)
                if resetRequest {
                    print("basarili")
                }
            } catch {
                print("reset didn't work")
            }
        }
        
    }
        
    func updateResetPasswordButtonState() {
        let isValid: Bool
        if let error = FormValidator.validateEmail(emailTextField.text!) {
            showError(error, for: emailTextField.errorLabel!)
            isValid = false
        } else {
            isValid = true
        }
        resetPasswordButton.setState(isValid ? .active : .inactive)
        
    }
    
    override func textFieldType(for textField: BNAAuthTextField) -> TextFieldType? {
        switch textField {
        case emailTextField: return .email
        default: return nil
        }
    }
    
    @objc override func textFieldEditingDidEnd(_ textField: UITextField) {
        super.textFieldEditingDidEnd(textField)
        updateResetPasswordButtonState()
    }
    

}
