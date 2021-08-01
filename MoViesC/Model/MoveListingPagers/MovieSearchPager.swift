//
//  MovieSearchPager.swift
//  MoViesC
//
//  Created by Lucas Lois on 1/8/21.
//

import Foundation

class MovieSearchPager: MovieListingPager {
    private let query: String

    init(query: String) {
        self.query = query
    }

    func fetchPage(page: Int, onSuccess: @escaping ((MoviePage?) -> Void)) {
        MovieManager.shared.searchMovies(named: query, page: page) { response in
            if let response = response {
                onSuccess(MoviePage(movies: response.movies, totalResults: response.totalResults, isFirst: response.page == 1))
            } else {
                onSuccess(nil)
            }
        }
    }
}
