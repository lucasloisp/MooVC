//
//  ViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 21/7/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usernameTextField.delegate = self
        passwordTextField.delegate = self
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
