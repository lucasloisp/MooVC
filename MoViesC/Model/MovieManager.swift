//
//  MovieManager.swift
//  MoViesC
//
//  Created by Lucas Lois on 24/7/21.
//

import Foundation

class MovieManager {
    typealias VoidHandler = () -> Void
    typealias Handle<T> = (T) -> Void

    static let shared = MovieManager()

    private init() {}

    func loadFavourites(completionHandler: @escaping Handle<[Movie]?>) {
        let accountId = SessionManager.share.accountId!
        let request = MovieDBRoute.loadFavourites(accountId: accountId)
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

    func loadMovies(for genre: Genre, completionHandler: @escaping Handle<[Movie]?>) {
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

    func loadMovieDetails(of movie: Movie, completionHandler: @escaping Handle<MovieDetails?>) {
        let request = MovieDBRoute.getMovieDetails(movie: movie)
        APIClient.shared.requestItem(request: request) { (result: Result<MovieDetails, Error>) in
            switch result {
            case .success(let movieDetails):
                completionHandler(movieDetails)
            case .failure(let err):
                // TODO: Implement
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
            } else {
                onError()
            }
        }
    }

    func searchMovies(named query: String, completionHandler: @escaping Handle<[Movie]?>) {
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
