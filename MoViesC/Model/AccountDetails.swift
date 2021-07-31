//
//  AccountDetails.swift
//  MoViesC
//
//  Created by Lucas Lois on 31/7/21.
//

import Foundation
import ObjectMapper

struct AccountDetails {
    let accountId: Int
}

extension AccountDetails: ImmutableMappable {
    init(map: Map) throws {
        accountId = try map.value("id")
    }
}
