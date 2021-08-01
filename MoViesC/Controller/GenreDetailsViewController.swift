//
//  GenreDetailsViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 26/7/21.
//

import UIKit

class GenreMoviesPager: MovieListingPager {
    private let genre: Genre

    init(for genre: Genre) {
        self.genre = genre
    }

    func fetchPage(page: Int, onSuccess: @escaping ((MoviePage?) -> Void)) {
        MovieManager.shared.loadMovies(for: genre, page: page) { response in
            if let response = response {
                onSuccess(MoviePage(movies: response.movies, totalResults: response.totalResults, isFirst: response.page == 1))
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
