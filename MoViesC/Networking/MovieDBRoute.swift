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
}

extension MovieDBRoute: APIRoute {
    var method: HTTPMethod {
        switch self {
        case .createRequestToken:
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
        }
    }

}
