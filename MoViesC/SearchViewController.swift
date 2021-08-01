//
//  SearchViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 27/7/21.
//

import UIKit

class MovieSearchPager: MovieListingPager {
    var totalItems: Int { return totalMovies }
    var isFetchInProgress: Bool { return _isFetchInProgress }

    private let query: String
    private var currentPage = 1
    private var totalMovies = 0
    private var _isFetchInProgress: Bool = false

    init(query: String) {
        self.query = query
    }

    func fetchPage(onSuccess: @escaping ((MoviePage?) -> Void)) {
        guard !_isFetchInProgress, !query.isEmpty else {
            return
        }
        _isFetchInProgress = true

        let page = currentPage
        MovieManager.shared.searchMovies(named: query, page: page) { response in
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
}

class SearchViewController: UIViewController, WithLoadingIndicator, WithSegues {
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!

    typealias SegueType = SeguesFromSelf
    enum SeguesFromSelf: String, PerformableSegue {
        case toMovieDetailsViewControllerSegue
    }

    private let movieController = InfiniteMovieListingController(pager: MovieSearchPager(query: ""))
    private var selectedMovie: Movie?

    var viewsThatHideOnLoading: [UIView] { return [moviesCollectionView] }

    override func viewDidLoad() {
        super.viewDidLoad()

        movieController.bind(to: self.moviesCollectionView)
        movieController.delegate = self
        movieController.pagerDelegate = self
        registerCellOnCollectionView()
        stopLoadingIndicator()
        searchBar.delegate = self
        emptyResults()
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.title = "Search"
    }

    @IBSegueAction func makeMovieDetailsViewController(_ coder: NSCoder) -> MovieDetailsViewController? {
        guard let movie = selectedMovie else { return nil }
        return MovieDetailsViewController(coder: coder, for: movie)
    }

    private func registerCellOnCollectionView() {
        let identifier = RatedMovieCollectionViewCell.identifier
        let movieNib = UINib(nibName: identifier, bundle: nil)
        moviesCollectionView.register(movieNib, forCellWithReuseIdentifier: identifier)
    }

    fileprivate func performSearch(query: String) {
        startLoadingIndicator()
        movieController.emptyMessage = "No results for \"\(query)\""
        movieController.restartWithPager(MovieSearchPager(query: query))
        movieController.fetchMovies()
    }

    fileprivate func emptyResults() {
        movieController.updateData(movies: [])
        moviesCollectionView.isHidden = true
    }

}

extension SearchViewController: InfiniteMovieListingControllerDelegate {
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

extension SearchViewController: MovieListingControllerDelegate {
    func didSelect(movie: Movie) {
        selectedMovie = movie
        perform(segue: .toMovieDetailsViewControllerSegue)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchAfterDebounce(searchBar)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        emptyResults()
        let selector = #selector(self.searchAfterDebounce(_:))
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: selector, object: searchBar)
        perform(selector, with: searchBar, afterDelay: 1)
    }

    @objc private func searchAfterDebounce(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.trimmingCharacters(in: .whitespaces) != "" else {
            return
        }

        performSearch(query: text)
    }
}
