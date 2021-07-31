//
//  ToDoAPIRoutes.swift
//  MoViesC
//
//  Created by Lucas Lois on 21/7/21.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

enum MovieDBRoute {
    case getGenres
    case discoverMoviesByGenre(genre: Genre)
    case getMovieDetails(movie: Movie)
    case searchMovies(named: String)
    case createRequestToken
    case createSession(accessToken: AccessToken)
    case validateTokenWithLogin(username: String, password: String, accessToken: AccessToken)
}

extension MovieDBRoute: APIRoute {
    var method: HTTPMethod {
        switch self {
        case .createSession:
            return .post
        case .validateTokenWithLogin:
            return .post
        default:
            return .get
        }
    }

    var sessionPolicy: APIRouteSessionPolicy {
        return .privateDomain
    }

    func asURLRequest() throws -> URLRequest {
        switch self {
        case .createRequestToken:
            return try encoded(path: "/authentication/token/new", params: [:])
        case .createSession(let accessToken):
            return try encoded(path: "/authentication/session/new", params: ["request_token": accessToken])
        case .validateTokenWithLogin(let username, let password, let accessToken):
        return try encoded(path: "/authentication/token/validate_with_login", params: ["username": username, "password": password, "request_token": accessToken])
        case .getGenres:
            return try encoded(path: "/genre/movie/list", params: [:])
        case .discoverMoviesByGenre(let genre):
            return try encoded(path: "/discover/movie", params: ["with_genres": "\(genre.tmbdId)"])
        case .getMovieDetails(let movie):
            return try encoded(path: "/movie/\(movie.tmbdId)", params: [:])
        case .searchMovies(let named):
            return try encoded(path: "/search/movie", params: ["query": named])
        }
    }

}
