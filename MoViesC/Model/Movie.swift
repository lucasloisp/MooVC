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
    let posterUrl: URL?
    let rating: Int
}

extension Movie: ImmutableMappable {
    init(map: Map) throws {
        title = try map.value("title")
        tmbdId = try map.value("id")
        let ratingOn10: Double = try map.value("vote_average")
        rating = Int(ratingOn10 / 2)
        let posterPath: String? = try map.value("poster_path")
        if let posterPath = posterPath {
            posterUrl = TheMovieDatabase.shared.imageUrl(for: posterPath)
        } else {
            posterUrl = nil
        }
    }
}
