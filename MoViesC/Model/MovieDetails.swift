//
//  MovieDetails.swift
//  MoViesC
//
//  Created by Lucas Lois on 25/7/21.
//

import Foundation

struct MovieDetails {
    let movie: Movie
    let tagline: String
    let status: String // TODO: one of: Rumored, Planned, In Production, Post Production, Released, Canceled
    let releaseDate: Date
}
