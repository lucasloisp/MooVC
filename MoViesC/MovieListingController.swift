//
//  GenreMoviesCollectionViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 23/7/21.
//

import UIKit

protocol MovieListingControllerDelegate: AnyObject {
    func didSelect(movie: Movie)
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

    func prepareMovieCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ movie: Movie) -> UICollectionViewCell {
        let cell = getRatedMovieCell(collectionView, indexPath)
        cell.configure(name: movie.title, poster: movie.posterUrl, starCount: movie.rating)
        return cell
    }

    private func getRatedMovieCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> RatedMovieCollectionViewCell {
        let identifier = RatedMovieCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        // swiftlint:disable:next force_cast
        return cell as! RatedMovieCollectionViewCell
    }
}

extension MovieListingController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 256)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = movies[indexPath.row]
        return prepareMovieCell(collectionView, indexPath, movie)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        delegate?.didSelect(movie: movie)
    }
}
