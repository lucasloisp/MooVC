//
//  RequestTokenCreation.swift
//  MoViesC
//
//  Created by Lucas Lois on 20/7/21.
//

import Foundation
import ObjectMapper

typealias AccessToken = String

enum Keys: String {
    case requestToken = "request_token"
    case success
}

struct RequestTokenCreation: ImmutableMappable {
    let requestToken: AccessToken
    let success: Bool

    init(map: Map) throws {
        requestToken = try map.value(Keys.requestToken.rawValue)
        success = try map.value(Keys.success.rawValue)
    }
}
