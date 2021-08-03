//
//  PeerViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 2/8/21.
//

import UIKit

class PeerViewController: UIViewController, WithSegues {
    @IBOutlet weak var moviesCollectionView: UICollectionView!

    typealias SegueType = SeguesFromSelf
    enum SeguesFromSelf: String, PerformableSegue {
        case toMovieDetailsViewControllerSegue
    }

    private let movieController = AppendingMovieListingController()
    private let movieSharing = MovieSharing.shared
    private var selectedMovie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let identifier = RatedMovieCollectionViewCell.identifier
        let movieNib = UINib(nibName: identifier, bundle: nil)
        moviesCollectionView.register(movieNib, forCellWithReuseIdentifier: identifier)

        movieController.emptyMessage = "Be the first to share a movie with your friends!"
        movieController.showingRating = false
        movieController.delegate = self
        movieController.bind(to: moviesCollectionView)

        movieSharing.delegate = self
        movieSharing.startSharing()
    }

    @IBSegueAction func makeMovieDetailsViewController(_ coder: NSCoder) -> MovieDetailsViewController? {
        guard let selectedMovie = selectedMovie else { return nil }
        return MovieDetailsViewController(coder: coder, for: selectedMovie)
    }
}

extension PeerViewController: MovieSharingDelegate {
    func receivedFromPeer(movieId: Int) {
        let movieStub = Movie(title: "", tmbdId: movieId, posterUrl: nil, rating: 0)
        MovieManager.shared.loadMovieDetails(of: movieStub) { details in
            if let movieDetails = details {
                self.movieController.append(movie: movieDetails.movie)
            } else {
                // FIXME: Handle the error
            }
        }
    }
}

extension PeerViewController: MovieListingControllerDelegate {
    func didSelect(movie: Movie) {
        movieSharing.share(movie: movie)
    }
}
