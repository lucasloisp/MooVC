//
//  LocalKeychainManager.swift
//  MoViesC
//
//  Created by Lucas Lois on 1/8/21.
//

import Foundation

class LocalKeychainManager {
    static let shared = LocalKeychainManager()

    private let sessionIDKey = "SessionID"
    private let accountIDKey = "AccountID"
    private let defaults = UserDefaults.standard

    private init() {}

    func storeUserSession(_ session: Session) {
        defaults.setValue(session.sessionId, forKey: sessionIDKey)
        defaults.setValue(session.accountId, forKey: accountIDKey)
    }

    func getUserSession() -> Session? {
        let sessionId = defaults.string(forKey: sessionIDKey)
        let accountId = defaults.integer(forKey: accountIDKey)
        if let sessionId = sessionId, accountId != 0 {
            return Session(sessionId: sessionId, accountId: accountId)
        }
        return nil
    }

    func clearStoredSession() {
        defaults.removeObject(forKey: sessionIDKey)
        defaults.removeObject(forKey: accountIDKey)
    }
}
