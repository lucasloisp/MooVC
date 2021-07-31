//
//  FavouritesViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 30/7/21.
//

import UIKit

class FavouritesViewController: UIViewController, WithSegues, WithLoadingIndicator {
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    typealias SegueType = SeguesFromSelf
    enum SeguesFromSelf: String, PerformableSegue {
        case toMovieDetailsViewControllerSegue
    }

    private let movieController: MovieListingController = MovieListingController(for: [])
    var selectedMovie: Movie?
    var viewsThatHideOnLoading: [UIView] {
        return [moviesCollectionView]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        movieController.bind(to: self.moviesCollectionView)
        movieController.delegate = self
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
        MovieManager.shared.loadFavourites { movies in
            self.movieController.updateData(movies: movies ?? [])
            self.moviesCollectionView.reloadData()
            self.stopLoadingIndicator()
        }
    }
}

extension FavouritesViewController: MovieListingControllerDelegate {
    func didSelect(movie: Movie) {
        selectedMovie = movie
        perform(segue: .toMovieDetailsViewControllerSegue)
    }
}
