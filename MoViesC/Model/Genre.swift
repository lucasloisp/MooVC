//
//  Genre.swift
//  MoViesC
//
//  Created by Lucas Lois on 22/7/21.
//

import Foundation
import ObjectMapper

private let validGenres = [
    "Action",
    "Adventure",
    "Animation",
    "Family",
    "History",
    "Music",
    "Romance",
    "Comedy"
]

struct Genre {
    let name: String
    let tmbdId: Int

    func isValidGenre() -> Bool {
        validGenres.contains(self.name)
    }
}

extension Genre: ImmutableMappable {
    init(map: Map) throws {
        name = try map.value("name")
        tmbdId = try map.value("id")
    }
}
