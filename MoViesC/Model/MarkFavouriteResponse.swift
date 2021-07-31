//
//  MarkFavouriteResponse.swift
//  MoViesC
//
//  Created by Lucas Lois on 31/7/21.
//

import Foundation
import ObjectMapper

struct MarkFavouriteResponse: ImmutableMappable {
    let message: String

    init(map: Map) throws {
        message = try map.value("status_message")
    }
}
