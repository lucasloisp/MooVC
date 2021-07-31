//
//  SessionManager.swift
//  MoViesC
//
//  Created by Lucas Lois on 28/7/21.
//

import Foundation

extension Notification.Name {
    static let didLogout = Notification.Name("didRequestLogout")
    static let didAuthenticate = Notification.Name("didAuthenticate")
}

struct UserCredentials {
    let username: String
    let password: String
}

typealias SessionID = String
typealias AccountID = Int

struct Session {
    let sessionId: SessionID
    let accountId: AccountID
}

class LocalKeychainManager {
    static let shared = LocalKeychainManager()

    private let defaults = UserDefaults.standard

    private init() {}

    private let sessionIDKey = "SessionID"
    private let accountIDKey = "AccountID"

    func storeUserSession(_ session: Session) {
        defaults.setValue(session.sessionId, forKey: sessionIDKey)
        defaults.setValue(session.accountId, forKey: accountIDKey)
    }

    func getUserSession() -> Session? {
        let sessionId = defaults.string(forKey: sessionIDKey)
        let accountId = defaults.integer(forKey: accountIDKey)
        guard let sessionId = sessionId, accountId != 0 else {
            return nil
        }
        return Session(sessionId: sessionId, accountId: accountId)
    }
}

class SessionManager {
    typealias VoidHandler = () -> Void
    typealias Handler<T> = (T) -> Void

    static let share = SessionManager()

    private let keychain = LocalKeychainManager.shared
    var sessionId: SessionID? {
        didSet {
            onSessionIDChange()
        }
    }
    var accountId: AccountID?

    fileprivate init() {
        if let session = keychain.getUserSession() {
            sessionId = session.sessionId
            accountId = session.accountId
        }
    }

    func login(with credentials: UserCredentials) {
        obtainValidatedRequestToken(credentials: credentials) { accessToken in
            self.obtainSessionId(accessToken) { sessionId in
                self.sessionId = sessionId
            } onError: {
                self.handleLoginError()
            }
        }
    }

    func checkIsLoggedIn() -> Bool {
        return sessionId != nil
    }

    func logout() {
        self.sessionId = nil
    }

    private func handleLoginError() {
        // TODO: Implement
        print("Error on login...")
    }

    private func onSessionIDChange() {
        guard sessionId != nil else {
            NotificationCenter.default.post(name: .didLogout, object: nil)
            return
        }
        getAccountId { accountDetails in
            guard let accountDetails = accountDetails else {
                NotificationCenter.default.post(name: .didLogout, object: nil)
                return
            }
            self.accountId = accountDetails.accountId
            self.keychain.storeUserSession(Session(sessionId: self.sessionId!, accountId: self.accountId!))
            NotificationCenter.default.post(name: .didAuthenticate, object: nil)
        }
    }

    private func getAccountId(completionHandler: @escaping Handler<AccountDetails?>) {
        let request = MovieDBRoute.loadAccountDetails
        APIClient.shared.requestItem(request: request) { (result: Result<AccountDetails, Error>) in
            switch result {
            case .success(let accountDetails):
                completionHandler(accountDetails)
            default:
                completionHandler(nil)
            }
        }
    }

    private func obtainSessionId(_ accessToken: AccessToken, onSuccess: @escaping Handler<SessionID>, onError: @escaping VoidHandler) {
        let request = MovieDBRoute.createSession(accessToken: accessToken)

        APIClient.shared.requestItem(request: request) { (result: Result<SessionIdCreation, Error>) in
            switch result {
            case .success(let sessionIdCreation):
                onSuccess(sessionIdCreation.sessionId)
            case .failure:
                onError()
            }
        }
    }

    private func obtainValidatedRequestToken(credentials: UserCredentials, onSuccess: @escaping Handler<AccessToken>) {
        obtainRequestToken { accessToken in
            self.validateAccessToken(accessToken, credentials: credentials) {
                onSuccess(accessToken)
            } onError: {
                self.handleLoginError()
            }
        } onError: {
            self.handleLoginError()
        }

    }

    private func validateAccessToken(_ accessToken: AccessToken, credentials: UserCredentials, onSuccess: @escaping VoidHandler, onError: @escaping VoidHandler) {
        let request = MovieDBRoute.validateTokenWithLogin(username: credentials.username, password: credentials.password, accessToken: accessToken)
        APIClient.shared.requestItem(request: request) { (result: Result<TokenValidationResponse, Error>) in
            switch result {
            case .success:
                onSuccess()
            case .failure:
                onError()
            }
        }

    }

    private func obtainRequestToken(onSuccess: @escaping Handler<AccessToken>, onError: @escaping VoidHandler) {
        APIClient.shared.requestItem(request: MovieDBRoute.createRequestToken) { (result: Result<RequestTokenCreation, Error>) in
            switch result {
            case .success(let requestTokencreation):
                onSuccess(requestTokencreation.requestToken)
            default:
                onError()
            }
        }
    }
}
