//
//  SearchViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 27/7/21.
//

import UIKit

class SearchViewController: UIViewController, WithLoadingIndicator, WithSegues {
    typealias SegueType = SeguesFromSelf
    enum SeguesFromSelf: String, PerformableSegue {
        case toMovieDetailsViewControllerSegue
    }

    private var movieController: MovieListingController?
    private var selectedMovie: Movie?

    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!

    var viewThatHidesOnLoading: UIView? { return searchBar }

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCellOnCollectionView()
        stopLoadingIndicator()
        searchBar.delegate = self
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
        self.startLoadingIndicator()
        GenreMoviesManager.shared.searchMovies(named: query) { movies in
            if let movies = movies {
                let movieController = MovieListingController(for: movies)
                movieController.bind(to: self.moviesCollectionView)
                movieController.delegate = self
                self.movieController = movieController
            }
            self.stopLoadingIndicator()
        }
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
}
