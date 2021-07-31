//
//  SessionIdCreation.swift
//  MoViesC
//
//  Created by Lucas Lois on 30/7/21.
//

import Foundation
import ObjectMapper

struct SessionIdCreation: ImmutableMappable {
    let sessionId: SessionID
    let success: Bool

    init(map: Map) throws {
        sessionId = try map.value("session_id")
        success = try map.value("success")
    }
}
