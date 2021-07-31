//
//  MovieDetailsViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 24/7/21.
//

import UIKit
import Kingfisher

enum FavouriteImages: String {
    case markedFavourite = "heart.fill"
    case notMarkedFavourite = "heart"

    var uiImage: UIImage {
        return UIImage(systemName: self.rawValue)!
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
    var movieIsFavourite: Bool! {
        didSet {
            self.updateFavouriteButtonIcon()
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
        loadMovieDetails()
    }

    private func updateFavouriteButtonIcon() {
        let favImage = FavouriteImages.select(isFavourite: movieIsFavourite)
        let image = favImage.uiImage
        guard let buttonItem = navigationItem.rightBarButtonItem else {
            setUpTheMarkAsFavouriteButton()
            return
        }
        buttonItem.image = image
    }

    private func setUpTheMarkAsFavouriteButton() {
        let favouriteIcon = FavouriteImages.select(isFavourite: movieIsFavourite)
        let image = favouriteIcon.uiImage
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(toggleIsFavourite))
        navigationItem.rightBarButtonItem = button
    }

    @objc private func toggleIsFavourite() {
        GenreMoviesManager.shared.markMovieAsFavourite(movie, as: !movieIsFavourite) {
            self.movieIsFavourite = !self.movieIsFavourite
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
        startLoadingIndicator()
        let request = MovieDBRoute.getMovieDetails(movie: movie)
        APIClient.shared.requestItem(request: request) { (result: Result<MovieDetails, Error>) in
            switch result {
            case .success(let movieDetails):
                self.movieDetails = movieDetails
                // TODO: Load movieIsFavourite from API
                self.movieIsFavourite = false
            case .failure(let err):
                // TODO: Implement
                print(err)
            }
            self.stopLoadingIndicator()
        }
    }

    private func updateMovieDetailsShowing() {
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
