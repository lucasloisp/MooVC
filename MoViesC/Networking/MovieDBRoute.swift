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
}

extension MovieDBRoute: APIRoute {
    var method: HTTPMethod {
        switch self {
        case .createRequestToken:
            return .get
        case .getGenres:
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
        case .getGenres:
            return try encoded(path: "/genre/movie/list", params: [:])
        }
    }

}
