//
//  TokenValidationResponse.swift
//  MoViesC
//
//  Created by Lucas Lois on 30/7/21.
//

import Foundation
import ObjectMapper

struct TokenValidationResponse: ImmutableMappable {
    let success: Bool

    init(map: Map) throws {
        success = try map.value("success")
    }
}
