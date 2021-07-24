//
//  GenreMoviesManager.swift
//  MoViesC
//
//  Created by Lucas Lois on 24/7/21.
//

import Foundation

class GenreMoviesManager {
    static let shared = GenreMoviesManager()
    private init() {}

    func loadGenres(onSuccess: @escaping (([(Genre, [Movie])]) -> Void), onError: @escaping (() -> Void)) {
        APIClient.shared.requestItem(request: MovieDBRoute.getGenres) { (result: Result<GenresResponse, Error>) in
            switch result {
            case .success(let genresResponse):
                let genres = genresResponse.genres
                var movies: [[Movie]] = Array(repeating: [], count: genres.count)
                let group = DispatchGroup()
                genres.enumerated().forEach { (index, genre) in
                    group.enter()
                    let request = MovieDBRoute.discoverMoviesByGenre(genre: genre)
                    APIClient.shared.requestItem(request: request) { (result: Result<DiscoverMovieResponse, Error>) in
                        switch result {
                        case .success(let response):
                            movies[index] = Array(response.movies.prefix(10))
                        case .failure(let err):
                            // TODO: Show the error to the user
                            print(err)
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                  onSuccess(Array(zip(genres, movies)))
                }
            case .failure(_):
                onError()
            }
        }

    }
}
