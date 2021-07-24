//
//  GenresResponse.swift
//  MoViesC
//
//  Created by Lucas Lois on 22/7/21.
//

import Foundation
import ObjectMapper

struct GenresResponse {
    let genres: [Genre]
}

extension GenresResponse: ImmutableMappable {
    init(map: Map) throws {
        genres = try map.value("genres").filter({ genre in
            return genre.isValidGenre()
        })
    }
}
