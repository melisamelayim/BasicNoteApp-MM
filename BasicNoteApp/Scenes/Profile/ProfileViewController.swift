//
//  ProfileViewController.swift
//  BasicNoteApp
//
//  Created by Max on 11.04.2025.
//

import UIKit

class ProfileViewController: BaseViewController {    
    @IBOutlet weak var fullNameTextField: BNAAuthTextField!
    @IBOutlet weak var fullNameErrorLabel: UILabel!
    
    @IBOutlet weak var emailTextField: BNAAuthTextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    @IBOutlet weak var saveButton: BNAButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    var originalName: String?
    var originalEmail: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()        
        setupListeners()
    }
    
    func setupUI() {
        fullNameTextField.text = originalName
        emailTextField.text = originalEmail 

        self.title = "Profile"
        
        fullNameErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        fullNameTextField.errorLabel = fullNameErrorLabel
        emailTextField.errorLabel = emailErrorLabel
        
        let buttonHeight: CGFloat = 63
        saveButton.setTitle("Save", for: .normal)
        saveButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        changePasswordButton.tintColor = Colors.BNAPrimaryColor
        
        signOutButton.tintColor = Colors.BNAErrorColor
        signOutButton.setTitle("Sign Out", for: .normal)
    }
    
    override func textFieldType(for textField: BNAAuthTextField) -> TextFieldType? {
        switch textField {
        case fullNameTextField: return .fullName
        case emailTextField: return .email
        default: return nil
        }
    }
    
    private func setupListeners() {
        fullNameTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldsDidChange() {
        checkIfFieldsChanged()
    }        
    
    private func checkIfFieldsChanged() {
        let isNameChanged = fullNameTextField.text != originalName
        let isEmailChanged = emailTextField.text != originalEmail
        saveButton.isEnabled = isNameChanged || isEmailChanged
        
        if saveButton.isEnabled {
            saveButton.setState(.active)
        } else {
            saveButton.setState(.inactive)
        }
    }

    @IBAction func saveButtonTapped(_ sender: BNAButton) {
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
                let isUserInfoChanged = try await UserService.shared.updateUserInfo(name: fullNameTextField.text!, email: emailTextField.text!)
                if isUserInfoChanged {
                    BNAToastView(
                        message: "Profile updated successfully",
                        backgroundColor: Colors.BNAGreenColor
                    ).show(in: self.view)
                    originalName = fullNameTextField.text
                    originalEmail = emailTextField.text 
                    saveButton.setState(.inactive)
                }
            } catch {
                BNAToastView(
                    message: APIError.unknownError.localizedDescription ,
                    backgroundColor: Colors.BNAErrorColor
                ).show(in: self.view)
            }            
        }
    }
    
    @IBAction func changePasswordButtonTapped(_ sender: Any) {
        // performs segue
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        AuthService.shared.logout()
        let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavVC = storyboard.instantiateViewController(withIdentifier: "AuthNavigationController")
        
        sceneDelegate?.window?.rootViewController = loginNavVC
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
}
