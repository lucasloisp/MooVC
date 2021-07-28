//
//  GenreMoviesCollectionViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 23/7/21.
//

import UIKit

protocol MovieListingControllerDelegate: AnyObject {
    func didSelect(movie: Movie)
    func loadMore(of genre: Genre)
}

class MovieListingController: NSObject {
    let movies: [Movie]

    weak var hostViewController: UIViewController?
    weak var delegate: MovieListingControllerDelegate?

    init(for movies: [Movie]) {
        self.movies = movies
    }

    func bind(to collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
    }
}

extension MovieListingController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = getGenreMovieCell(collectionView, indexPath)
        let movie = movies[indexPath.row]

        cell.configure(name: movie.title, poster: movie.posterUrl)

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
