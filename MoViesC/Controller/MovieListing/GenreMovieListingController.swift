//
//  GenreMovieListingController.swift
//  MoViesC
//
//  Created by Lucas Lois on 27/7/21.
//

import UIKit

protocol GenreMovieListingControllerDelegate: AnyObject {
    func loadMore(of genre: Genre)
}

class GenreMovieListingController: MovieListingController {
    let genre: Genre

    weak var genreDelegate: GenreMovieListingControllerDelegate?

    init(for genre: Genre) {
        self.genre = genre
        super.init()
    }

    func bind(to cell: GenreTableViewCell) {
        cell.configure(for: genre.name)
        self.bind(to: cell.moviesCollectionView!)
    }

    override func prepareMovieCell(
        _ collectionView: UICollectionView,
        _ indexPath: IndexPath,
        _ movie: Movie) -> UICollectionViewCell {
        let cell = getGenreMovieCell(collectionView, indexPath)
        cell.configure(name: movie.title, poster: movie.posterUrl)
        return cell
    }

    private func getGenreMovieCell(
        _ collectionView: UICollectionView,
        _ indexPath: IndexPath) -> GenreMovieCollectionViewCell {
        let identifier = GenreMovieCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        // swiftlint:disable:next force_cast
        return cell as! GenreMovieCollectionViewCell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = getFooterView(collectionView, at: indexPath)
            footerView.delegate = self
            return footerView
        default:
            fatalError("Invalid element type")
        }
    }

    private func getFooterView(
        _ collectionView: UICollectionView,
        at indexPath: IndexPath) -> GenreMovieCollectionReusableView {
        let identifier = GenreMovieCollectionReusableView.identifier
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: identifier, for: indexPath)
        // swiftlint:disable:next force_cast
        return view as! GenreMovieCollectionReusableView
    }
}

extension GenreMovieListingController: GenreMovieCollectionReusableViewDelegate {
    func didTap() {
        genreDelegate?.loadMore(of: genre)
    }
}
