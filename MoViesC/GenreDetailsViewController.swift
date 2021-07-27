//
//  GenreDetailsViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 26/7/21.
//

import UIKit

class GenreDetailsViewController: UIViewController, WithLoadingIndicator {
    let genre: Genre
    var genreMoviesController: GenreMoviesCollectionViewController?

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
                let genreMoviesController = GenreMoviesCollectionViewController(for: self.genre, with: movies)
                genreMoviesController.delegate = self
                genreMoviesController.bind(to: self.moviesCollectionView)
                self.genreMoviesController = genreMoviesController
            }
            self.stopLoadingIndicator()
        }

    }

}

extension GenreDetailsViewController: GenreMoviesCollectionViewControllerDelegate {
    func didSelect(movie: Movie) {
        // TODO: Implement
    }

    func loadMore(of genre: Genre) {
        // TODO: Implement
    }
}
