//
//  LoginViewControllerTests.swift
//  MoViesCTests
//
//  Created by Lucas Lois on 21/7/21.
//

import XCTest
@testable import MoViesC

class LoginViewControllerTests: XCTestCase {
    
    var viewController: LoginViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        _ = viewController.view
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSignInButtonIsDisabledWithEmptyInputs() {
        XCTAssertFalse(viewController.signInButton.isEnabled)
    }
    
    func testSignInButtonIsEnabledWhenBothFieldsHaveAValue() {
        typeInTheUsername()
        typeInThePassword()
        XCTAssertTrue(viewController.signInButton.isEnabled)
    }
    
    private func typeInTheUsername() {
        let usernameField = viewController.usernameTextField!
        typeIntoField(usernameField)
    }
    
    private func typeInThePassword() {
        let passwordField = viewController.passwordTextField!
        typeIntoField(passwordField)
    }
    
    fileprivate func typeIntoField(_ field: UITextField) {
        field.text = "a"
        let _ =  field.delegate?.textField!(
            field,
            shouldChangeCharactersIn: NSMakeRange(0, 1),
            replacementString: "a"
        )
    }
    
}
