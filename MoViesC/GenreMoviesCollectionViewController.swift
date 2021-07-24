//
//  GenreMoviesCollectionViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 23/7/21.
//

import UIKit

class GenreMoviesCollectionViewController: NSObject {
    let genre: Genre
    var movies: [Movie] = []

    private var collectionView: UICollectionView?

    init(for genre: Genre) {
        self.genre = genre
    }

    func bind(to cell: GenreTableViewCell) {
        cell.configure(for: genre.name)
        collectionView = cell.moviesCollectionView
        loadMovies()

        collectionView?.dataSource = self
        collectionView?.reloadData()
    }

    private func loadMovies() {
        let request = MovieDBRoute.discoverMoviesByGenre(genre: genre)

        APIClient.shared
            .requestItem(request: request) { (result: Result<DiscoverMovieResponse, Error>) in
                switch result {
                case .success(let response):
                    self.movies = response.movies
                    self.collectionView?.reloadData()
                case .failure(let err):
                    // TODO: Show the error to the user
                    print(err)
                }
            }
    }
}

extension GenreMoviesCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = getGenreMovieCell(collectionView, indexPath)
        let movie = movies[indexPath.row]

        var url: URL?
        if let posterUrl = movie.posterUrl {
            url = URL(string: "https://image.tmdb.org/t/p/w500" + posterUrl)
        }

        cell.configure(name: movie.title, poster: url)

        return cell
    }

    private func getGenreMovieCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> GenreMovieCollectionViewCell {
        let identifier = GenreMovieCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        // swiftlint:disable:next force_cast
        return cell as! GenreMovieCollectionViewCell
    }
}
