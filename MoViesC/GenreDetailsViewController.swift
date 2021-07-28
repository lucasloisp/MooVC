//
//  GenreDetailsViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 26/7/21.
//

import UIKit

class GenreDetailsViewController: UIViewController, WithLoadingIndicator, WithSegues {
    typealias SegueType = SeguesFromSelf
    enum SeguesFromSelf: String, PerformableSegue {
        case toMovieDetailsViewControllerSegue
    }

    let genre: Genre
    var genreMoviesController: MovieListingController?
    var selectedMovie: Movie?

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!

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

        let genreMovieNib = UINib(nibName: GenreMovieCollectionViewCell.identifier, bundle: nil)
        let identifier = GenreMovieCollectionViewCell.identifier
        moviesCollectionView.register(genreMovieNib, forCellWithReuseIdentifier: identifier)

        self.startLoadingIndicator()
        GenreMoviesManager.shared.loadMovies(for: genre) { movies in
            if let movies = movies {
                let genreMoviesController = MovieListingController(for: self.genre, with: movies)
                genreMoviesController.delegate = self
                genreMoviesController.bind(to: self.moviesCollectionView)
                self.genreMoviesController = genreMoviesController
            }
            self.stopLoadingIndicator()
        }

    }

    @IBSegueAction func makeMovieDetailsViewController(_ coder: NSCoder) -> MovieDetailsViewController? {
        guard let movie = selectedMovie else { return nil }
        return MovieDetailsViewController(coder: coder, for: movie)
    }

}

extension GenreDetailsViewController: GenreMoviesCollectionViewControllerDelegate {
    func didSelect(movie: Movie) {
        self.selectedMovie = movie
        perform(segue: .toMovieDetailsViewControllerSegue)
    }

    func loadMore(of genre: Genre) {
        // TODO: Implement
    }
}
