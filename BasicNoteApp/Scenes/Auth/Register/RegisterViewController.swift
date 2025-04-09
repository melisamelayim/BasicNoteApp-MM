//
//  RegisterViewController.swift
//  BasicNoteApp
//
//  Created by Max on 7.04.2025.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var signUpSecLabel: UILabel!
    
    @IBOutlet weak var fullNameTextField: BNAAuthTextField!
    @IBOutlet weak var emailTextField: BNAAuthTextField!
    @IBOutlet weak var passwordTextfield: BNAAuthTextField!
    
    @IBOutlet weak var emptyErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var signUpButton: BNAButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpLabel.font = .inter(.title1)
        signUpSecLabel.font = .inter(.title3)
        signUpSecLabel.textColor = Colors.BNAGrayDark
        
        fullNameTextField.placeholder = "Full Name"
        emailTextField.placeholder = "Email Address"
        passwordTextfield.placeholder = "Password" 
                
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.setTitle("Sign Up", for: .normal)
        
    }
    
    @IBAction func forgetPasswordButton(_ sender: Any) {
    }
    
   
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let name = fullNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextfield.text ?? ""
        
        var isValid = true
        
        if let emptyError = FormValidator.emptyField(name) {
            emptyErrorLabel.text = FormValidator.errorMessage(for: .emptyField)
            emptyErrorLabel.isHidden = false
            isValid = false
        } else {
            emptyErrorLabel.isHidden = true
        }
        
        if let emailError = FormValidator.validateEmail(email) {
            emailErrorLabel.text = FormValidator.errorMessage(for: .invalidEmail)
            emailErrorLabel.isHidden = false
            isValid = false
        } else {
            emailErrorLabel.isHidden = true
        }
        
        if let passwordError = FormValidator.validatePassword(password) {
            passwordErrorLabel.text = FormValidator.errorMessage(for: .invalidPassword)
            passwordErrorLabel.isHidden = false
            isValid = false
        } else {
            passwordErrorLabel.isHidden = true
        }
        
        if isValid {
            print("register successfull")
        }
        
    }
}
