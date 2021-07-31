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

    private let movieController: MovieListingController = MovieListingController(for: [])
    private var selectedMovie: Movie?

    var viewsThatHideOnLoading: [UIView] { return [searchBar] }

    override func viewDidLoad() {
        super.viewDidLoad()

        movieController.bind(to: self.moviesCollectionView)
        movieController.delegate = self
        registerCellOnCollectionView()
        stopLoadingIndicator()
        searchBar.delegate = self
        showResults(movies: [])
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
        emptyResults()
        MovieManager.shared.searchMovies(named: query) { movies in
            if let movies = movies {
                self.showResults(movies: movies)
            }
            self.stopLoadingIndicator()
        }
    }

    fileprivate func showResults(movies: [Movie]) {
        movieController.updateData(movies: movies)
        moviesCollectionView.reloadData()
        self.moviesCollectionView.isHidden = false
    }

    fileprivate func emptyResults() {
        movieController.updateData(movies: [])
        moviesCollectionView.reloadData()
        moviesCollectionView.isHidden = true
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
