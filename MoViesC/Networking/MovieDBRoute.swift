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
    case createRequestToken
    case getGenres
    case discoverMoviesByGenre(genre: Genre)
    case getMovieDetails(movie: Movie)
    case searchMovies(named: String)
}

extension MovieDBRoute: APIRoute {
    var method: HTTPMethod {
        return .get
    }

    var sessionPolicy: APIRouteSessionPolicy {
        return .privateDomain
    }

    func asURLRequest() throws -> URLRequest {
        switch self {
        case .createRequestToken:
            return try encoded(path: "/authentication/token/new", params: [:])
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
