//
//  GenreDetailsViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 26/7/21.
//

import UIKit

class GenreDetailsViewController: UIViewController, WithLoadingIndicator, WithSegues {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!

    typealias SegueType = SeguesFromSelf
    enum SeguesFromSelf: String, PerformableSegue {
        case toMovieDetailsViewControllerSegue
    }

    private let genre: Genre
    private let genreMoviesController = MovieListingController()
    private var selectedMovie: Movie?
    var viewsThatHideOnLoading: [UIView] { return [moviesCollectionView] }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) is not implemented")
    }

    init?(coder: NSCoder, for genre: Genre) {
        self.genre = genre
        super.init(coder: coder)
        self.title = genre.name
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        genreMoviesController.delegate = self
        genreMoviesController.bind(to: moviesCollectionView)

        let identifier = RatedMovieCollectionViewCell.identifier
        let movieNib = UINib(nibName: identifier, bundle: nil)
        moviesCollectionView.register(movieNib, forCellWithReuseIdentifier: identifier)

        self.startLoadingIndicator()
        MovieManager.shared.loadMovies(for: genre) { movies in
            if let movies = movies {
                self.genreMoviesController.updateData(movies: movies)
            }
            self.stopLoadingIndicator()
        }

    }

    @IBSegueAction func makeMovieDetailsViewController(_ coder: NSCoder) -> MovieDetailsViewController? {
        guard let movie = selectedMovie else { return nil }
        return MovieDetailsViewController(coder: coder, for: movie)
    }

}

extension GenreDetailsViewController: MovieListingControllerDelegate {
    func didSelect(movie: Movie) {
        self.selectedMovie = movie
        perform(segue: .toMovieDetailsViewControllerSegue)
    }
}
