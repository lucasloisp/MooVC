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
    fileprivate var movies: [Movie] = []
    fileprivate var moviesCount: Int { movies.count }
    var emptyMessage: String = ""
    var showingRating: Bool = true

    weak var delegate: MovieListingControllerDelegate?
    weak var collectionView: UICollectionView?

    override init() {}

    func bind(to collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView = collectionView
    }

    func prepareMovieCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ movie: Movie) -> UICollectionViewCell {
        let cell = getRatedMovieCell(collectionView, indexPath)
        let starCount = showingRating ? movie.rating : nil
        cell.configure(name: movie.title, poster: movie.posterUrl, starCount: starCount)
        return cell
    }

    final func updateData(movies: [Movie]) {
        self.movies = movies
        collectionView?.reloadData()
    }

    fileprivate final func getRatedMovieCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> RatedMovieCollectionViewCell {
        let identifier = RatedMovieCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        // swiftlint:disable:next force_cast
        return cell as! RatedMovieCollectionViewCell
    }
}

extension MovieListingController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var emptyStateLabel: UILabel? {
        if self.emptyMessage.isEmpty {
            return nil
        }
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.sizeToFit()
        messageLabel.text = self.emptyMessage
        return messageLabel
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movies.isEmpty {
            collectionView.backgroundView = emptyStateLabel
        } else {
            collectionView.backgroundView = nil
        }
        return moviesCount
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width
        let itemsPerRow: Int = Int(availableWidth) / 100
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)

        return CGSize(width: widthPerItem, height: widthPerItem * 2)
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

protocol InfiniteMovieListingControllerDelegate: AnyObject {
    func onFetchSucceeded(for indexes: [Int]?)
    func onFetchFailed()
}

protocol MovieListingPager: AnyObject {
    func fetchPage(onSuccess: @escaping ((MoviePage?) -> Void))
    var totalItems: Int { get }
    var isFetchInProgress: Bool { get }
}

class InfiniteMovieListingController: MovieListingController {
    weak var pagerDelegate: InfiniteMovieListingControllerDelegate?

    private var pager: MovieListingPager

    override var moviesCount: Int { return pager.totalItems }

    init(pager: MovieListingPager) {
        self.pager = pager
        super.init()
    }

    func restartWithPager(_ pager: MovieListingPager) {
        self.pager = pager
        self.movies = []
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

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
            guard let moviePage = moviePage, self.pager === thisPager else {
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
