//
//  LocalKeychainManager.swift
//  MoViesC
//
//  Created by Lucas Lois on 1/8/21.
//

import Foundation
import SwiftKeychainWrapper

class LocalKeychainManager {
    static let shared = LocalKeychainManager()

    private let sessionIDKey = "SessionID"
    private let accountIDKey = "AccountID"
    // This value is necessary because the keychain persists across installs, but sessions should not.
    private let hasStoredValueInKeychainKey = "hasStoredValueInKeychainKey"
    private let keychain = KeychainWrapper.standard
    private let userDefaults = UserDefaults.standard

    private init() {}

    func storeUserSession(_ session: Session) {
        keychain.set(session.sessionId, forKey: sessionIDKey)
        keychain.set(session.accountId, forKey: accountIDKey)
        userDefaults.setValue(true, forKey: hasStoredValueInKeychainKey)
    }

    func getUserSession() -> Session? {
        let hasStoredValueInKeychain = userDefaults.bool(forKey: hasStoredValueInKeychainKey)
        let sessionId = keychain.string(forKey: sessionIDKey)
        let accountId = keychain.integer(forKey: accountIDKey)
        if hasStoredValueInKeychain, let sessionId = sessionId, let accountId = accountId, accountId != 0 {
            return Session(sessionId: sessionId, accountId: accountId)
        }
        return nil
    }

    func clearStoredSession() {
        keychain.removeObject(forKey: sessionIDKey)
        keychain.removeObject(forKey: accountIDKey)
    }
}
