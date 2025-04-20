//
//  RegisterViewController.swift
//  BasicNoteApp
//
//  Created by Max on 7.04.2025.
//


import UIKit

class RegisterViewController: BaseViewController {
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var signUpSecLabel: UILabel!
    @IBOutlet weak var haveAccountLabel: UILabel!
    
    @IBOutlet weak var fullNameTextField: BNAAuthTextField!
    @IBOutlet weak var emailTextField: BNAAuthTextField!
        
    @IBOutlet weak var passwordTextField: BNAAuthTextField!
    

    @IBOutlet weak var emptyErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var signUpButton: BNAButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextFields()
        updateSignUpButtonState()
    }
    
    func setupUI() {
        signUpLabel.font = .inter(.title1)
        signUpSecLabel.font = .inter(.title3)
        haveAccountLabel.font = .inter(.title3)
        signUpSecLabel.textColor = Colors.BNAGrayDark
        
        fullNameTextField.placeholder = "Full Name"
        emailTextField.placeholder = "Email Address"
        passwordTextField.placeholder = "Password"
        
        passwordTextField.isSecureTextEntry = true
                        
        let buttonHeight: CGFloat = 63
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
                
        haveAccountLabel.textColor = Colors.BNAGrayDark
        haveAccountLabel.text = "Already have an account?"
        signInButton.tintColor = Colors.BNAPrimaryColor
        signInButton.setTitle("Sign in now", for: .normal)
        
        emptyErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        
        fullNameTextField.errorLabel = emptyErrorLabel
        emailTextField.errorLabel = emailErrorLabel
        passwordTextField.errorLabel = passwordErrorLabel
    }
   
    @IBAction func signUpButtonTapped(_ sender: BNAButton) {
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
                let isUserRegistered = try await AuthService.shared.register(fullName: fullNameTextField.text!, withEmail: emailTextField.text!, password: passwordTextField.text!)
                
                if isUserRegistered {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let navVC = storyboard.instantiateViewController(withIdentifier: "NotesNavigationController")
                        navVC.modalPresentationStyle = .fullScreen
                        self.present(navVC, animated: true)
                    }
                }
            } catch {
                print("register didn't work")
            }
        }
        
    }
    
    func updateSignUpButtonState() {
        let allFieldsValid = getAllTextFields().allSatisfy { textField in
            validateTextField(textField) == nil && !(textField.text?.isEmpty ?? true)
        }
                
        signUpButton.setState(allFieldsValid ? .active : .inactive)
    }
    
    override func textFieldType(for textField: BNAAuthTextField) -> TextFieldType? {
        switch textField {
        case fullNameTextField: return .fullName
        case emailTextField: return .email
        case passwordTextField: return .password
        default: return nil
        }
    }
    
    @objc override func textFieldEditingDidEnd(_ textField: UITextField) {
        super.textFieldEditingDidEnd(textField)
        updateSignUpButtonState()
    }
        
    @objc override func textFieldEditingDidBegin(_ textField: UITextField) {
        super.textFieldEditingDidBegin(textField)
        updateSignUpButtonState()
    }
    
    @IBAction func backToLoginTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    
    
}
