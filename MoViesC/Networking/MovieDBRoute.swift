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
    case loadAccountDetails
    case markAsFavourite(movie: Movie, accountId: Int, mark: Bool)
    case loadFavourites(accountId: Int)
}

extension MovieDBRoute: APIRoute {
    var method: HTTPMethod {
        switch self {
        case .createSession,
             .validateTokenWithLogin,
             .markAsFavourite:
            return .post
        default:
            return .get
        }
    }

    var sessionPolicy: APIRouteSessionPolicy {
        switch self {
        case .loadAccountDetails,
             .markAsFavourite,
             .loadFavourites,
             .getMovieDetails:
            return .privateDomain
        default:
            return .publicDomain
        }
    }

    func asURLRequest() throws -> URLRequest {
        switch self {
        case .createRequestToken:
            return try encoded(path: "/authentication/token/new", params: [:])
        case .markAsFavourite(let movie, let accountId, let mark):
            return try encoded(path: "/account/\(accountId)/favorite", params: ["media_type": "movie", "media_id": movie.tmbdId, "favorite": mark])
        case .createSession(let accessToken):
            return try encoded(path: "/authentication/session/new", params: ["request_token": accessToken])
        case .validateTokenWithLogin(let username, let password, let accessToken):
        return try encoded(path: "/authentication/token/validate_with_login", params: ["username": username, "password": password, "request_token": accessToken])
        case .getGenres:
            return try encoded(path: "/genre/movie/list", params: [:])
        case .discoverMoviesByGenre(let genre):
            return try encoded(path: "/discover/movie", params: ["with_genres": "\(genre.tmbdId)"])
        case .getMovieDetails(let movie):
            return try encoded(path: "/movie/\(movie.tmbdId)", params: ["append_to_response": "account_states"])
        case .searchMovies(let named):
            return try encoded(path: "/search/movie", params: ["query": named])
        case .loadFavourites(let accountId):
            return try encoded(path: "/account/\(accountId)/favorite/movies", params: [:])
        case .loadAccountDetails:
            return try encoded(path: "/account", params: [:])
        }
    }

}
