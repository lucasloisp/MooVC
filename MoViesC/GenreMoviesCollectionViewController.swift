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
    var posterImage: UIImage?

    private var collectionView: UICollectionView!

    init(for genre: Genre) {
        self.genre = genre
    }

    func bind(to cell: GenreTableViewCell) {
        cell.configure(for: genre.name)
        collectionView = cell.moviesCollectionView

        collectionView.dataSource = self

        loadMovies()
        cell.moviesCollectionView.reloadData()
    }

    private func loadMovies() {
        let someMovie = Movie(title: "Inception", tmbdId: 1, posterUrl: "https://developer.apple.com/home/images/hero-xcode-13/xcode-13-large.png")

        movies = [someMovie, someMovie, someMovie]

        if let posterUrl = someMovie.posterUrl,
           let url = URL(string: posterUrl),
           let imageData = try? Data(contentsOf: url) {
            posterImage = UIImage(data: imageData)
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

        cell.configure(name: movie.title, poster: posterImage)

        return cell
    }

    private func getGenreMovieCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> GenreMovieCollectionViewCell {
        let identifier = GenreMovieCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        // swiftlint:disable:next force_cast
        return cell as! GenreMovieCollectionViewCell
    }
}
