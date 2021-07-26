//
//  TheMovieDatabase.swift
//  MoViesC
//
//  Created by Lucas Lois on 26/7/21.
//

import Foundation

class TheMovieDatabase {
    static let shared = TheMovieDatabase()

    private let imageBaseUrl = "https://image.tmdb.org/t/p/w500"

    private init() {}

    func imageUrl(for path: String) -> URL? {
        return URL(string: imageBaseUrl + path)
    }
}
