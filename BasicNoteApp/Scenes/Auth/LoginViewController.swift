//
//  LoginViewController.swift
//  BasicNoteApp
//
//  Created by Max on 11.04.2025.
//
import UIKit

class LoginViewController: BaseViewController {
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginSecondaryLabel: UILabel!
    
    @IBOutlet weak var emailTextField: BNAAuthTextField!
    @IBOutlet weak var passwordTextField: BNAAuthTextField!
        
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var loginButton: BNAButton!
    
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        loginLabel.font = .inter(.title1)
        loginSecondaryLabel.font = .inter(.title3)
        loginSecondaryLabel.textColor = Colors.BNAGrayDark
        
        emailTextField.placeholder = "Email Address"
        passwordTextField.placeholder = "Password"
        
        passwordTextField.isSecureTextEntry = true

        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        emailTextField.errorLabel = emailErrorLabel
        passwordTextField.errorLabel = passwordErrorLabel
        
        let buttonHeight: CGFloat = 63
        loginButton.setTitle("Login", for: .normal)
        loginButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        registerLabel.font = .inter(.title3)
        registerLabel.textColor = Colors.BNAGrayDark
        registerLabel.text = "New user?"
        registerButton.tintColor = Colors.BNAPrimaryColor
        registerButton.setTitle("Sign up now", for: .normal)        
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        // segue performed
    }
    
    @IBAction func LoginButtonTapped(_ sender: BNAButton) {
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
                let isUserLoggedIn = try await AuthService.shared.login(withEmail: emailTextField.text!, password: passwordTextField.text!)
                
                if isUserLoggedIn {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let navVC = storyboard.instantiateViewController(withIdentifier: "NotesNavigationController")
                        navVC.modalPresentationStyle = .fullScreen
                        self.present(navVC, animated: true)
                    }
                }
            } catch {
                BNAToastView(
                    message: APIError.invalidCredentials.localizedDescription,
                    backgroundColor: Colors.BNAErrorColor
                ).show(in: self.view)
            }
            
        }
        
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        // send to register vc
    }
    
    override func textFieldType(for textField: BNAAuthTextField) -> TextFieldType? {
        switch textField {
        case emailTextField: return .email
        case passwordTextField: return .password
        default: return nil
        }
    }
    
    @objc override func textFieldEditingDidEnd(_ textField: UITextField) {
        super.textFieldEditingDidEnd(textField)
        updateLoginButtonState()
    }
        
    @objc override func textFieldEditingDidBegin(_ textField: UITextField) {
        super.textFieldEditingDidBegin(textField)        
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
                textFieldEditingDidEnd(textField)
                passwordTextField.becomeFirstResponder()            
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func updateLoginButtonState() {
        let allFieldsValid = getAllTextFields().allSatisfy { textField in
            validateTextField(textField) == nil && !(textField.text?.isEmpty ?? true)
        }
        loginButton.setState(allFieldsValid ? .active : .inactive)
    }
        
}
