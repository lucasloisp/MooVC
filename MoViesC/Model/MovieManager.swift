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

    func loadFavourites(page: Int, completionHandler: @escaping Handle<DiscoverMovieResponse?>) {
        let accountId = SessionManager.share.session!.accountId
        let request = MovieDBRoute.loadFavourites(accountId: accountId, page: page)
        APIClient.shared.requestItem(request: request) { (result: Result<DiscoverMovieResponse, Error>) in
            switch result {
            case .success(let response):
                completionHandler(response)
            case .failure(_):
                completionHandler(nil)
            }
        }
    }

    func loadSimilarMovies(to movie: Movie, onSuccess: @escaping Handle<[Movie]>) {
        let request = MovieDBRoute.loadSimilarMovies(movie: movie)
        APIClient.shared.requestItem(request: request) { (result: Result<DiscoverMovieResponse, Error>) in
            if case .success(let response) = result {
                onSuccess(response.movies)
            }
        }
    }

    func loadMovies(for genre: Genre, page: Int, completionHandler: @escaping Handle<DiscoverMovieResponse?>) {
        let request = MovieDBRoute.discoverMoviesByGenre(genre: genre, page: page)
        APIClient.shared.requestItem(request: request) { (result: Result<DiscoverMovieResponse, Error>) in
            switch result {
            case .success(let response):
                completionHandler(response)
            case .failure(_):
                completionHandler(nil)
            }
        }
    }

    func loadMovies(for genre: Genre, completionHandler: @escaping Handle<[Movie]?>) {
        self.loadMovies(for: genre, page: 1) { response in
            completionHandler(response.map { $0.movies })
        }
    }

    func loadMovieDetails(of movie: Movie, completionHandler: @escaping Handle<MovieDetails?>) {
        let request = MovieDBRoute.getMovieDetails(movie: movie)
        APIClient.shared.requestItem(request: request) { (result: Result<MovieDetails, Error>) in
            switch result {
            case .success(let movieDetails):
                completionHandler(movieDetails)
            case .failure(_):
                // TODO: Implement
                completionHandler(nil)
            }
        }
    }

    func markMovieAsFavourite(
        _ movie: Movie,
        as favourite: Bool,
        onSuccess: @escaping VoidHandler,
        onError: @escaping VoidHandler) {
        let accountId = SessionManager.share.session!.accountId
        let request: MovieDBRoute = .markAsFavourite(movie: movie, accountId: accountId, mark: favourite)
        APIClient.shared.requestItem(request: request) { (result: Result<MarkFavouriteResponse, Error>) in
            if case .success = result {
                onSuccess()
            } else {
                onError()
            }
        }
    }

    func searchMovies(named query: String, page: Int, completionHandler: @escaping Handle<DiscoverMovieResponse?>) {
        let request = MovieDBRoute.searchMovies(named: query, page: page)
        APIClient.shared.requestItem(request: request) { (result: Result<DiscoverMovieResponse, Error>) in
            switch result {
            case .success(let response):
                completionHandler(response)
            case .failure(_):
                // TODO: Show the error to the user
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
                        } else {
                            onError()
                            return
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
