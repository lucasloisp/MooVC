//
//  SearchViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 27/7/21.
//

import UIKit

class MovieSearchPager: MovieListingPager {
    private var query: String = "the"

    func fetchPage(page: Int, onSuccess: @escaping ((MoviePage?) -> Void)) {
        MovieManager.shared.searchMovies(named: query, page: page) { response in
            if let response = response {
                let total = response.totalResults
                onSuccess(MoviePage(movies: response.movies, page: response.page, total: total))
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

    private let movieController = InfiniteMovieListingController(pager: MovieSearchPager())
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
        movieController.fetchMovies()
        // TODO: Reset the search pager
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
        performSearch(query: searchBar.text!)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            emptyResults()
            return
        }

        performSearch(query: searchBar.text!)
    }
}
