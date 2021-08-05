//
//  ErrorMessageManager.swift
//  MoViesC
//
//  Created by Lucas Lois on 4/8/21.
//

import Foundation
import SwiftMessages

class ErrorMessageManager {
    static let shared = ErrorMessageManager()
    private init() {}

    func showError(message: String) {
        let errorMessageView = MessageView.viewFromNib(layout: .cardView)
        errorMessageView.configureTheme(.error)
        errorMessageView.configureContent(title: "Oopsie", body: message)
        errorMessageView.button?.isHidden = true
        SwiftMessages.show(view: errorMessageView)
    }
}
