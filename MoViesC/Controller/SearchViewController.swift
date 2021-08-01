//
//  SearchViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 27/7/21.
//

import UIKit

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
        moviesCollectionView.contentOffset.y = 0
    }

    fileprivate func emptyResults() {
        moviesCollectionView.isHidden = true
    }
}

extension SearchViewController: InfiniteMovieListingControllerDelegate {}

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
