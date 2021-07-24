//
//  Todo.swift
//  Test
//
//  Created by Lucas Lois on 20/7/21.
//

import Foundation
import ObjectMapper

struct RequestTokenCreation: ImmutableMappable {
    let requestToken: String
    let success: Bool

    init(map: Map) throws {
        requestToken = try map.value(Keys.requestToken.rawValue)
        success = try map.value(Keys.success.rawValue)
    }
}

enum Keys: String {
    case requestToken = "request_token"
    case success
}
