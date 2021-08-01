//
//  GenreMoviesPager.swift
//  MoViesC
//
//  Created by Lucas Lois on 1/8/21.
//

import Foundation

class GenreMoviesPager: MovieListingPager {
    private let genre: Genre

    init(for genre: Genre) {
        self.genre = genre
    }

    func fetchPage(page: Int, onSuccess: @escaping ((MoviePage?) -> Void)) {
        MovieManager.shared.loadMovies(for: genre, page: page) { response in
            if let response = response {
                onSuccess(MoviePage(movies: response.movies, totalResults: response.totalResults, isFirst: response.page == 1))
            } else {
                onSuccess(nil)
            }
        }
    }
}
