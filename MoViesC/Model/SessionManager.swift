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

struct UserCredentials {
    let username: String
    let password: String
}

typealias SessionID = String

class SessionManager {
    typealias VoidHandler = () -> Void
    typealias Handler<T> = (T) -> Void

    static let share = SessionManager()

    var sessionId: SessionID?

    fileprivate init() {}

    func login(with credentials: UserCredentials) {
        return self.putSessionId("MOCK SESSION ID")
        obtainValidatedRequestToken(credentials: credentials) { accessToken in
            self.obtainSessionId(accessToken) { sessionId in
                self.putSessionId(sessionId)
            } onError: {
                self.handleLoginError()
            }
        }
    }

    private func handleLoginError() {
        // TODO: Implement
        print("Error on login...")
    }

    private func putSessionId(_ sessionId: SessionID) {
        self.sessionId = sessionId
        NotificationCenter.default.post(name: .didAuthenticate, object: nil)
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

    func checkIsLoggedIn() -> Bool {
        // TODO: Implement with local storage
        return false
    }

    func logout() {
        NotificationCenter.default.post(name: .didRequestLogout, object: nil)
    }
}
