//
//  ViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 21/7/21.
//

import UIKit

class LoginViewController: UIViewController, WithLoadingIndicator {
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!

    var viewsThatHideOnLoading: [UIView] {
        return [signInButton, usernameTextField, passwordTextField]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        errorLabel.isHidden = true
        activityIndicatorView.isHidden = true
        usernameTextField.delegate = self
        passwordTextField.delegate = self

        if let authenticationError = SessionManager.share.authenticationError {
            errorLabel.isHidden = false
            errorLabel.text = authenticationError
        }
    }

    @IBAction func loginButtonPress(_ sender: Any) {
        errorLabel.isHidden = true
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        errorLabel.isHidden = true
        startLoadingIndicator()
        SessionManager.share.login(with: UserCredentials(username: username, password: password)) { error in
            if let error = error {
                self.errorLabel.text = error
                self.errorLabel.isHidden = false
            }
            self.stopLoadingIndicator()
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    private func formIsFilledIn() -> Bool {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text else {
            return false
        }

        return !username.isEmpty && !password.isEmpty
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        signInButton.isEnabled = formIsFilledIn()
        return true
    }
}
