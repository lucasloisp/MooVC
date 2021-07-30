//
//  SessionManager.swift
//  MoViesC
//
//  Created by Lucas Lois on 28/7/21.
//

import Foundation

extension Notification.Name {
    static let didRequestLogout = Notification.Name("didRequestLogout")
    static let didAuthenticate = Notification.Name("didAuthenticate")
}

class SessionManager {
    static let share = SessionManager()

    fileprivate init() {}

    func login(as username: String, with password: String) {
        // TODO: Validate credentials through the API
        if username == "user" && password == "password" {
            NotificationCenter.default.post(name: .didAuthenticate, object: nil)
        }
    }

    func checkIsLoggedIn() -> Bool {
        // TODO: Implement with local storage
        return false
    }

    func logout() {
        NotificationCenter.default.post(name: .didRequestLogout, object: nil)
    }
}
