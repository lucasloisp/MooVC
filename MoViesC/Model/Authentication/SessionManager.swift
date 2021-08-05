//
//  SessionManager.swift
//  MoViesC
//
//  Created by Lucas Lois on 28/7/21.
//

import Foundation

class SessionManager {
    typealias VoidHandler = () -> Void
    typealias Handler<T> = (T) -> Void

    static let share = SessionManager()

    var session: Session? {
        if let sessionId = sessionId {
            return Session(sessionId: sessionId, accountId: accountId ?? 0)
        }
        return nil
    }
    var isLoggedIn: Bool {
        return sessionId != nil
    }

    private(set) var authenticationError: String?
    private let keychain = LocalKeychainManager.shared
    private let errorMessageInvalidCredentials = "Invalid credentials"

    private var sessionId: SessionID? {
        didSet {
            onSessionIDChange()
        }
    }
    private var accountId: AccountID?

    fileprivate init() {
        if let session = keychain.getUserSession() {
            sessionId = session.sessionId
            accountId = session.accountId
        }
    }

    func login(with credentials: UserCredentials, onError: @escaping Handler<String?>) {
        authenticationError = nil
        obtainValidatedRequestToken(credentials: credentials, onError: onError) { accessToken in
            self.obtainSessionId(accessToken) { sessionId in
                self.sessionId = sessionId
            } onError: {
                onError(self.errorMessageInvalidCredentials)
            }
        }
    }

    func invalidateSession() {
        guard sessionId != nil, accountId != nil else {
            return
        }
        self.authenticationError = "Session expired"
        self.sessionId = nil
    }

    func logout() {
        self.sessionId = nil
    }

    private func onSessionIDChange() {
        guard sessionId != nil else {
            keychain.clearStoredSession()
            self.accountId = nil
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

    private func obtainSessionId(
        _ accessToken: AccessToken,
        onSuccess: @escaping Handler<SessionID>,
        onError: @escaping VoidHandler) {
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

    private func obtainValidatedRequestToken(
        credentials: UserCredentials,
        onError: @escaping Handler<String>,
        onSuccess: @escaping Handler<AccessToken>) {
        obtainRequestToken { accessToken in
            self.validateAccessToken(accessToken, credentials: credentials) {
                onSuccess(accessToken)
            } onError: {
                onError(self.errorMessageInvalidCredentials)
            }
        } onError: {
            onError(self.errorMessageInvalidCredentials)
        }

    }

    private func validateAccessToken(
        _ accessToken: AccessToken,
        credentials: UserCredentials,
        onSuccess: @escaping VoidHandler,
        onError: @escaping VoidHandler) {
        let request = MovieDBRoute.validateTokenWithLogin(username: credentials.username,
                                                          password: credentials.password,
                                                          accessToken: accessToken)
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
        APIClient.shared
            .requestItem(request: MovieDBRoute.createRequestToken) {(result: Result<RequestTokenCreation, Error>) in
            switch result {
            case .success(let requestTokencreation):
                onSuccess(requestTokencreation.requestToken)
            default:
                onError()
            }
        }
    }
}
