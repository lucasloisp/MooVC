//
//  SearchViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 27/7/21.
//

import UIKit

class SearchViewController: UIViewController, WithLoadingIndicator {
    private var movieController: MovieListingController?

    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCellOnCollectionView()
        self.startLoadingIndicator()
        GenreMoviesManager.shared.searchMovies(named: "Incep") { movies in
            if let movies = movies {
                let movieController = MovieListingController(for: movies)
                movieController.bind(to: self.moviesCollectionView)
                movieController.delegate = self
                self.movieController = movieController
            }
            self.stopLoadingIndicator()
        }
    }

    private func registerCellOnCollectionView() {
        let identifier = GenreMovieCollectionViewCell.identifier
        let movieNib = UINib(nibName: identifier, bundle: nil)
        moviesCollectionView.register(movieNib, forCellWithReuseIdentifier: identifier)
    }

}

extension SearchViewController: MovieListingControllerDelegate {
    func didSelect(movie: Movie) {
        // TODO: Implement
    }

    func loadMore(of genre: Genre) {
        // TODO: This should not be here
    }
}
