//
//  GenreMovieListingController.swift
//  MoViesC
//
//  Created by Lucas Lois on 27/7/21.
//

import UIKit

class GenreMovieListingController: MovieListingController {
    let genre: Genre

    init(for genre: Genre, with movies: [Movie]) {
        self.genre = genre
        super.init(for: movies)
    }

    func bind(to cell: GenreTableViewCell) {
        cell.configure(for: genre.name)
        self.bind(to: cell.moviesCollectionView!)
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
}

extension GenreMovieListingController: GenreMovieCollectionReusableViewDelegate {
    func didTap() {
        delegate?.loadMore(of: genre)
    }
}
