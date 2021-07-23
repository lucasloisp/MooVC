//
//  DiscoverMovieResponse.swift
//  MoViesC
//
//  Created by Lucas Lois on 22/7/21.
//

import Foundation
import ObjectMapper

struct DiscoverMovieResponse {
    let page: Int
    let movies: [Movie]
}

extension DiscoverMovieResponse: ImmutableMappable {
    init(map: Map) throws {
        page = try map.value("page")
        movies = try map.value("results")
    }
}
