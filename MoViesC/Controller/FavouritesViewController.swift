//
//  FavouritesViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 30/7/21.
//

import UIKit

class FavouritesPager: MovieListingPager {
    var totalItems: Int { return totalMovies }
    var isFetchInProgress: Bool { return _isFetchInProgress }

    private var currentPage = 1
    private var totalMovies = 0
    private var _isFetchInProgress: Bool = false

    func fetchPage(onSuccess: @escaping ((MoviePage?) -> Void)) {
        guard !_isFetchInProgress else {
            return
        }
        _isFetchInProgress = true

        let page = currentPage

        MovieManager.shared.loadFavourites(page: page) { response in
            self._isFetchInProgress = false
            if let response = response {
                self.currentPage += 1
                self.totalMovies = response.totalResults
                onSuccess(MoviePage(movies: response.movies, isFirst: response.page == 1))
            } else {
                onSuccess(nil)
            }
        }
    }

    func restart() {
        currentPage = 1
        totalMovies = 0
    }
}

class FavouritesViewController: UIViewController, WithSegues, WithLoadingIndicator {
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    typealias SegueType = SeguesFromSelf
    enum SeguesFromSelf: String, PerformableSegue {
        case toMovieDetailsViewControllerSegue
    }

    private let movieController = InfiniteMovieListingController(pager: FavouritesPager())
    var selectedMovie: Movie?
    var viewsThatHideOnLoading: [UIView] {
        return [moviesCollectionView]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        movieController.emptyMessage = "You have not marked any movies as favourites"
        movieController.bind(to: self.moviesCollectionView)
        movieController.delegate = self
        movieController.pagerDelegate = self
        registerCellOnCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.title = "Favourites"

        loadAccountFavourites()
    }

    @IBSegueAction func buildMovieDetailsViewController(_ coder: NSCoder) -> MovieDetailsViewController? {
        guard let movie = selectedMovie else { return nil }
        return MovieDetailsViewController(coder: coder, for: movie)
    }

    private func registerCellOnCollectionView() {
        let identifier = RatedMovieCollectionViewCell.identifier
        let movieNib = UINib(nibName: identifier, bundle: nil)
        moviesCollectionView.register(movieNib, forCellWithReuseIdentifier: identifier)
    }

    private func loadAccountFavourites() {
        startLoadingIndicator()
        movieController.restart()
        movieController.fetchMovies()
    }
}

extension FavouritesViewController: MovieListingControllerDelegate {
    func didSelect(movie: Movie) {
        selectedMovie = movie
        perform(segue: .toMovieDetailsViewControllerSegue)
    }
}

extension FavouritesViewController: InfiniteMovieListingControllerDelegate {
    func onFetchSucceeded(for indexes: [Int]?) {
        guard let indexes = indexes else {
            stopLoadingIndicator()
            moviesCollectionView.reloadData()
            return
        }
        let newIndexPathsToReload = indexes.map { IndexPath(row: $0, section: 0) }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        moviesCollectionView.reloadItems(at: indexPathsToReload)
    }

    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = moviesCollectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }

    func onFetchFailed() {
        // TODO: Indicate the error to the user
    }
}
