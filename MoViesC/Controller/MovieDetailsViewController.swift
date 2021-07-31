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

    var toggle: Self {
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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    let movie: Movie
    let formatter: DateFormatter
    var movieDetails: MovieDetails? {
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

        loadPosterImage()
        startLoadingIndicator()
        loadMovieDetails()
    }

    private func updateFavouriteButtonIcon() {
        let favImage = FavouriteImages.select(isFavourite: movieDetails!.isFavourite)
        let image = favImage.uiImage
        guard let buttonItem = navigationItem.rightBarButtonItem else {
            setUpTheMarkAsFavouriteButton()
            return
        }
        buttonItem.image = image
    }

    private func setUpTheMarkAsFavouriteButton() {
        let favouriteIcon = FavouriteImages.select(isFavourite: movieDetails!.isFavourite)
        let image = favouriteIcon.uiImage
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(toggleIsFavourite))
        navigationItem.rightBarButtonItem = button
    }

    private func toggleFavouriteButtonImage() {
        let favImage = FavouriteImages.select(isFavourite: movieDetails!.isFavourite).toggle
        let image = favImage.uiImage
        navigationItem.rightBarButtonItem?.image = image
    }

    @objc private func toggleIsFavourite() {
        toggleFavouriteButtonImage()
        MovieManager.shared.markMovieAsFavourite(movie, as: !movieDetails!.isFavourite) {
            self.loadMovieDetails()
        } onError: {
            // TODO: Show an error prompt
            print("Error during marking movie as favourite")
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
            }
        }
        let request = MovieDBRoute.getMovieDetails(movie: movie)
        APIClient.shared.requestItem(request: request) { (result: Result<MovieDetails, Error>) in
            switch result {
            case .success(let movieDetails):
                self.movieDetails = movieDetails
            case .failure(let err):
                // TODO: Implement
                print(err)
            }
            self.stopLoadingIndicator()
        }
    }

    private func updateMovieDetailsShowing() {
        // Optimistic rendering of the UI
        self.updateFavouriteButtonIcon()
        guard let movieDetails = movieDetails else {
            hideMovieDetails()
            return
        }
        taglineLabel.text = movieDetails.tagline
        statusLabel.text = movieDetails.status
        if let releaseDate = movieDetails.releaseDate {
            releaseDateLabel.text = formatter.string(from: releaseDate)
        } else {
            releaseDateLabel.text = "Unknown"
        }
    }

    var viewsThatHideOnLoading: [UIView] {
        return [taglineLabel, statusLabel, releaseDateLabel]
    }

    func hideMovieDetails() {
        viewsThatHideOnLoading.forEach { view in
            view.isHidden = true
        }
    }
}
