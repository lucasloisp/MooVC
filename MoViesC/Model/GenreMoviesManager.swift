//
//  GenreMoviesManager.swift
//  MoViesC
//
//  Created by Lucas Lois on 24/7/21.
//

import Foundation

class GenreMoviesManager {
    typealias VoidHandler = () -> Void

    static let shared = GenreMoviesManager()

    private init() {}

    func loadMovies(for genre: Genre, completionHandler: @escaping (([Movie]?) -> Void)) {
        let request = MovieDBRoute.discoverMoviesByGenre(genre: genre)
        APIClient.shared.requestItem(request: request) { (result: Result<DiscoverMovieResponse, Error>) in
            switch result {
            case .success(let response):
                completionHandler(response.movies)
            case .failure(let err):
                // TODO: Show the error to the user
                print(err)
                completionHandler(nil)
            }
        }
    }

    func markMovieAsFavourite(_ movie: Movie, as favourite: Bool, onSuccess: @escaping VoidHandler, onError: @escaping VoidHandler) {
        let accountId = SessionManager.share.accountId!
        let request: MovieDBRoute = .markAsFavourite(movie: movie, accountId: accountId, mark: favourite)
        APIClient.shared.requestItem(request: request) { (result: Result<MarkFavouriteResponse, Error>) in
            if case .success = result {
                onSuccess()
            }
            onError()
        }
    }

    func searchMovies(named query: String, completionHandler: @escaping (([Movie]?) -> Void)) {
        let request = MovieDBRoute.searchMovies(named: query)
        APIClient.shared.requestItem(request: request) { (result: Result<DiscoverMovieResponse, Error>) in
            switch result {
            case .success(let response):
                completionHandler(response.movies)
            case .failure(let err):
                // TODO: Show the error to the user
                print(err)
                completionHandler(nil)
            }
        }
    }

    func loadGenres(onSuccess: @escaping (([(Genre, [Movie])]) -> Void), onError: @escaping (() -> Void)) {
        APIClient.shared.requestItem(request: MovieDBRoute.getGenres) { (result: Result<GenresResponse, Error>) in
            switch result {
            case .success(let genresResponse):
                let genres = genresResponse.genres
                var movies: [[Movie]] = Array(repeating: [], count: genres.count)
                let group = DispatchGroup()
                genres.enumerated().forEach { (index, genre) in
                    group.enter()
                    self.loadMovies(for: genre) {
                        if let apiMovies = $0 {
                            movies[index] = Array(apiMovies.prefix(10))
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
