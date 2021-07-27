//
//  GenreMoviesCollectionViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 23/7/21.
//

import UIKit

protocol GenreMoviesCollectionViewControllerDelegate: AnyObject {
    func didSelect(movie: Movie)
    func loadMore(of genre: Genre)
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

    func bind(to collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
    }

    func bind(to cell: GenreTableViewCell) {
        cell.configure(for: genre.name)
        self.bind(to: cell.moviesCollectionView!)
    }
}

extension GenreMoviesCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, GenreMovieCollectionReusableViewDelegate {
    func didTap() {
        delegate?.loadMore(of: genre)
    }

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

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = getFooterView(collectionView, at: indexPath)
            footerView.delegate = self
            return footerView
        default:
            fatalError("Invalid element type")
        }
    }

    private func getFooterView(_ collectionView: UICollectionView, at indexPath: IndexPath) -> GenreMovieCollectionReusableView {
        let identifier = GenreMovieCollectionReusableView.identifier
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath)
        // swiftlint:disable:next force_cast
        return view as! GenreMovieCollectionReusableView
    }

    private func getGenreMovieCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> GenreMovieCollectionViewCell {
        let identifier = GenreMovieCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        // swiftlint:disable:next force_cast
        return cell as! GenreMovieCollectionViewCell
    }
}
