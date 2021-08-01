//
//  GenreDetailsViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 26/7/21.
//

import UIKit

class GenreMoviesPager: MovieListingPager {
    var totalItems: Int { return totalMovies }
    var isFetchInProgress: Bool { return _isFetchInProgress }

    private let genre: Genre
    private var currentPage = 1
    private var totalMovies = 0
    private var _isFetchInProgress: Bool = false

    init(for genre: Genre) {
        self.genre = genre
    }

    func fetchPage(onSuccess: @escaping ((MoviePage?) -> Void)) {
        guard !_isFetchInProgress else {
            return
        }
        _isFetchInProgress = true

        let page = currentPage
        MovieManager.shared.loadMovies(for: genre, page: page) { response in
            self._isFetchInProgress = false
            if let response = response {
                self.currentPage += 1
                self.totalMovies = response.totalResults
                onSuccess(MoviePage(movies: response.movies, page: response.page, total: response.totalResults))
            } else {
                onSuccess(nil)
            }
        }
    }
}

class GenreDetailsViewController: UIViewController, WithLoadingIndicator, WithSegues {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!

    typealias SegueType = SeguesFromSelf
    enum SeguesFromSelf: String, PerformableSegue {
        case toMovieDetailsViewControllerSegue
    }

    private let genre: Genre
    private let genreMoviesController: InfiniteMovieListingController
    private var selectedMovie: Movie?
    var viewsThatHideOnLoading: [UIView] { return [moviesCollectionView] }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) is not implemented")
    }

    init?(coder: NSCoder, for genre: Genre) {
        self.genre = genre
        self.genreMoviesController = InfiniteMovieListingController(pager: GenreMoviesPager(for: genre))
        super.init(coder: coder)
        self.title = genre.name
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        genreMoviesController.delegate = self
        genreMoviesController.pagerDelegate = self
        genreMoviesController.bind(to: moviesCollectionView)

        let identifier = RatedMovieCollectionViewCell.identifier
        let movieNib = UINib(nibName: identifier, bundle: nil)
        moviesCollectionView.register(movieNib, forCellWithReuseIdentifier: identifier)

        self.startLoadingIndicator()
        genreMoviesController.fetchMovies()
    }

    @IBSegueAction func makeMovieDetailsViewController(_ coder: NSCoder) -> MovieDetailsViewController? {
        guard let movie = selectedMovie else { return nil }
        return MovieDetailsViewController(coder: coder, for: movie)
    }

}

extension GenreDetailsViewController: InfiniteMovieListingControllerDelegate {
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

extension GenreDetailsViewController: MovieListingControllerDelegate {
    func didSelect(movie: Movie) {
        self.selectedMovie = movie
        perform(segue: .toMovieDetailsViewControllerSegue)
    }
}
