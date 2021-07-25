//
//  MovieDetails.swift
//  MoViesC
//
//  Created by Lucas Lois on 25/7/21.
//

import Foundation
import ObjectMapper

struct MovieDetails {
    let movie: Movie
    let tagline: String
    let status: String // TODO: one of: Rumored, Planned, In Production, Post Production, Released, Canceled
    let releaseDate: Date?
}

extension MovieDetails: ImmutableMappable {
    init(map: Map) throws {
        movie = try Movie(map: map)
        tagline = try map.value("tagline")
        status = try map.value("status")
        let releaseDateString: String = try map.value("release_date")

        let dateFormatter = DateFormatter(withFormat: "YYYY-MM-DD", locale: Locale.current.identifier)
        releaseDate = dateFormatter.date(from: releaseDateString)

    }
}
