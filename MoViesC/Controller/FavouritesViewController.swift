//
//  FavouritesViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 30/7/21.
//

import UIKit

class FavouritesPager: MovieListingPager {
    func fetchPage(page: Int, onSuccess: @escaping ((MoviePage?) -> Void)) {
        MovieManager.shared.loadFavourites(page: page) { response in
            if let response = response {
                onSuccess(MoviePage(movies: response.movies, totalResults: response.totalResults, isFirst: response.page == 1))
            } else {
                onSuccess(nil)
            }
        }
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

extension FavouritesViewController: InfiniteMovieListingControllerDelegate {}
