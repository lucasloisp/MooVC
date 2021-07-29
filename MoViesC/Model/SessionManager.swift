//
//  SessionManager.swift
//  MoViesC
//
//  Created by Lucas Lois on 28/7/21.
//

import Foundation

extension Notification.Name {
    static let didRequestLogout = Notification.Name("didRequestLogout")
}

class SessionManager {
    static let share = SessionManager()

    fileprivate init() {}

    func login(as username: String, with password: String, onSuccess: () -> Void) {
        // TODO: Validate credentials through the API
        if username == "lucasloisp" && password == "password" {
            onSuccess()
        }
    }

    func checkIsLoggedIn() -> Bool {
        // TODO: Implement with local storage
        return true
    }

    func logout() {
        NotificationCenter.default.post(name: .didRequestLogout, object: nil)
    }
}
