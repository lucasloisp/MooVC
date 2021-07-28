//
//  SearchViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 27/7/21.
//

import UIKit

class SearchViewController: UIViewController, WithLoadingIndicator {

    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCellOnCollectionView()
        self.startLoadingIndicator()
        GenreMoviesManager.shared.searchMovies(named: "Incep") { movies in
            if let movies = movies {
//                TODO: Set the movies in the collectionview
//                let moviesController = MoviesCollectionViewController(with: movies)
//                moviesController.delegate = self
//                self.moviesCollectionView.delegate = moviesController
//                self.moviesCollectionView.dataSource = moviesController
//                self.moviesController = moviesController
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
        // TODO: This should be optional
    }
}
