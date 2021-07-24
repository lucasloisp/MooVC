//
//  GenreMoviesCollectionViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 23/7/21.
//

import UIKit

protocol GenreMoviesCollectionViewControllerDelegate: AnyObject {
    func didSelect(movie: Movie)
}

class GenreMoviesCollectionViewController: NSObject {
    let genre: Genre
    let movies: [Movie]

    weak var hostViewController: UIViewController?
    weak var delegate: GenreMoviesCollectionViewControllerDelegate?

    init(for genre: Genre, with movies: [Movie]) {
        self.genre = genre
        self.movies = movies
    }

    func bind(to cell: GenreTableViewCell) {
        cell.configure(for: genre.name)
        let collectionView = cell.moviesCollectionView!

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
    }
}

extension GenreMoviesCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        delegate?.didSelect(movie: movie)
    }

    private func getGenreMovieCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> GenreMovieCollectionViewCell {
        let identifier = GenreMovieCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        // swiftlint:disable:next force_cast
        return cell as! GenreMovieCollectionViewCell
    }
}
