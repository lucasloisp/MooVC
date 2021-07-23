//
//  Movie.swift
//  MoViesC
//
//  Created by Lucas Lois on 22/7/21.
//

import Foundation
import ObjectMapper

struct Movie {
    let title: String
    let tmbdId: Int
    let posterUrl: String?
}

extension Movie: ImmutableMappable {
    init(map: Map) throws {
        title = try map.value("title")
        tmbdId = try map.value("id")
        posterUrl = try map.value("poster_path")
    }
}
