//
//  InfiniteMovieListingController.swift
//  MoViesC
//
//  Created by Lucas Lois on 1/8/21.
//

import UIKit

class InfiniteMovieListingController: MovieListingController {
    weak var pagerDelegate: InfiniteMovieListingControllerDelegate?

    private var pager: MovieListingPageManager

    override var moviesCount: Int { return pager.totalItems }

    init(pager: MovieListingPager) {
        self.pager = MovieListingPageManager(pager: pager)
        super.init()
    }

    func restartWithPager(_ pager: MovieListingPager) {
        self.pager = MovieListingPageManager(pager: pager)
        self.movies = []
    }

    func restart() {
        self.movies = []
        self.pager.restart()
    }

    override func bind(to collectionView: UICollectionView) {
        super.bind(to: collectionView)
        collectionView.prefetchDataSource = self
        collectionView.showsVerticalScrollIndicator = false
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoadingCell(for: indexPath) { return }
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoadingCell(for: indexPath) {
            let cell = self.getRatedMovieCell(collectionView, indexPath)
            cell.configureAsLoading()
            return cell
        } else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }

    func fetchMovies() {
        let thisPager = pager
        thisPager.fetchPage { moviePage in
            guard self.pager === thisPager else { return }
            guard let moviePage = moviePage else {
                self.pagerDelegate?.onFetchFailed()
                return
            }
            self.movies.append(contentsOf: moviePage.movies)

            if moviePage.isFirst {
                self.pagerDelegate?.onFetchSucceeded(for: nil)
            } else {
                self.pagerDelegate?.onFetchSucceeded(for: self.calculateIndexesToReload(from: moviePage.movies))
            }
        }
    }

    fileprivate func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= self.movies.count
    }

    private func calculateIndexesToReload(from newMovies: [Movie]) -> [Int] {
      let startIndex = movies.count - newMovies.count
      let endIndex = movies.count
      return (startIndex..<endIndex).map { $0 }
    }
}

extension InfiniteMovieListingController: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            self.fetchMovies()
        }
    }

}
