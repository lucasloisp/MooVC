//
//  MovieDetailsViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 24/7/21.
//

import UIKit
import Kingfisher

enum FavouriteImages {
    case markedFavourite
    case notMarkedFavourite

    var uiImage: UIImage {
        switch self {
        case .markedFavourite:
            return UIImage(systemName: "heart.fill")!
        case .notMarkedFavourite:
            return UIImage(systemName: "heart")!
        }
    }

    var invert: Self {
        switch self {
        case .markedFavourite:
            return .notMarkedFavourite
        case .notMarkedFavourite:
            return .markedFavourite
        }
    }

    static func select(isFavourite: Bool) -> Self {
        if isFavourite {
            return .markedFavourite
        } else {
            return  .notMarkedFavourite
        }
    }
}

class MovieDetailsViewController: UIViewController, WithLoadingIndicator {
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var similarLabel: UILabel!
    @IBOutlet weak var releaseDateContainerView: UIView!
    @IBOutlet weak var statusContainerView: UIView!
    @IBOutlet weak var likeBarButtonItem: UIBarButtonItem!

    var viewsThatHideOnLoading: [UIView] {
        return [taglineLabel, statusContainerView, releaseDateContainerView]
    }
    private let movie: Movie
    private let formatter: DateFormatter
    private let movieController = MovieListingController()
    private var movieDetails: MovieDetails? {
        didSet {
            self.updateMovieDetailsShowing()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }

    init?(coder: NSCoder, for movie: Movie) {
        self.movie = movie
        self.formatter = DateFormatter()
        self.formatter.dateStyle = .medium
        self.formatter.timeStyle = .none
        super.init(coder: coder)
        self.title = movie.title
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let identifier = RatedMovieCollectionViewCell.identifier
        let movieNib = UINib(nibName: identifier, bundle: nil)
        moviesCollectionView.register(movieNib, forCellWithReuseIdentifier: identifier)

        movieController.emptyMessage = "No similar movies were found"
        movieController.showingRating = false
        movieController.delegate = self
        movieController.bind(to: moviesCollectionView)

        likeBarButtonItem.isEnabled = false

        loadPosterImage()
        startLoadingIndicator()
        loadMovieDetails()
        loadSimilarMovies()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        posterImageView.layer.cornerRadius = 8.0
        statusContainerView.layer.cornerRadius = 4.0
        statusContainerView.layer.masksToBounds = true
        releaseDateContainerView.layer.cornerRadius = 4.0
        releaseDateContainerView.layer.masksToBounds = true
    }

    func hideMovieDetails() {
        viewsThatHideOnLoading.forEach { view in
            view.isHidden = true
        }
    }

    private func loadSimilarMovies() {
        MovieManager.shared.loadSimilarMovies(to: movie) { movies in
            self.movieController.updateData(movies: movies)
        }
    }

    private func loadPosterImage() {
        guard let posterUrl = movie.posterUrl else {
            posterImageView.image = UIImage(systemName: "xmark.rectangle")
            return
        }
        let placeholder = UIImage(systemName: "photo")
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.kf.setImage(with: posterUrl, placeholder: placeholder, options: nil) { result in
            switch result {
            case .success(_):
                self.posterImageView.contentMode = .scaleAspectFill
            default:
                return
            }
        }
    }

    private func loadMovieDetails() {
        MovieManager.shared.loadMovieDetails(of: movie) { movieDetails in
            if let movieDetails = movieDetails {
                self.movieDetails = movieDetails
            } else {
                ErrorMessageManager.shared.showError(message: "There was an error loading the details of this movie")
            }
            self.stopLoadingIndicator()
        }
    }

    private func updateMovieDetailsShowing() {
        guard let movieDetails = movieDetails else {
            hideMovieDetails()
            return
        }
        self.refreshFavouriteButtonIcon()
        taglineLabel.text = movieDetails.tagline
        statusLabel.text = movieDetails.status
        if let releaseDate = movieDetails.releaseDate {
            releaseDateLabel.text = formatter.string(from: releaseDate)
        } else {
            releaseDateLabel.text = "Unknown"
        }
    }

    private func refreshFavouriteButtonIcon() {
        let favImage = FavouriteImages.select(isFavourite: movieDetails!.isFavourite)
        let image = favImage.uiImage
        likeBarButtonItem.image = image
        likeBarButtonItem.isEnabled = true
    }

    private func invertLikeButtonImage() {
        let favImage = FavouriteImages.select(isFavourite: movieDetails!.isFavourite)
        let image = favImage.invert.uiImage
        likeBarButtonItem.image = image
    }

    @IBAction func toggleIsFavourite(_ sender: Any) {
        invertLikeButtonImage()
        let willBeFavourite: Bool = !movieDetails!.isFavourite
        MovieManager.shared.markMovieAsFavourite(movie, as: willBeFavourite) {
            self.loadMovieDetails()
        } onError: {
            self.refreshFavouriteButtonIcon()
            let message = "There was a problem \(willBeFavourite ? "" : "un")marking this movie as a favourite"
            ErrorMessageManager.shared.showError(message: message)
        }
    }

}

extension MovieDetailsViewController: MovieListingControllerDelegate {
    func didSelect(movie: Movie) {
        let storyboard = self.storyboard!
        let identifier = "MovieDetailsViewController"
        let viewController = storyboard.instantiateViewController(identifier: identifier, creator: { coder in
            MovieDetailsViewController(coder: coder, for: movie)
        })
        navigationController?.pushViewController(viewController, animated: true)
    }
}
