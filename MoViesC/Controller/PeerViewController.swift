//
//  PeerViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 2/8/21.
//

import UIKit

class PeerViewController: UIViewController, WithSegues {
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var instructionsView: UIView!

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

        moviesCollectionView.isHidden = true
        instructionsView.isHidden = false

        movieSharing.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.title = "Peers"
    }

    @IBSegueAction func makeMovieDetailsViewController(_ coder: NSCoder) -> MovieDetailsViewController? {
        guard let selectedMovie = selectedMovie else { return nil }
        return MovieDetailsViewController(coder: coder, for: selectedMovie)
    }

    @IBAction func didRequestStartSharing(_ sender: Any) {
        movieSharing.startSharing()

        tabBarItem.image = UIImage(systemName: "person.2.fill")
        moviesCollectionView.isHidden = false
        instructionsView.isHidden = true
    }
}

extension PeerViewController: MovieSharingDelegate {
    func connectedToCount(peerCount: Int) {
        guard peerCount > 0 else {
            tabBarItem.badgeValue = nil
            return
        }
        tabBarItem.badgeValue = String(peerCount)
    }

    func receivedFromPeer(movieId: Int) {
        let movieStub = Movie(title: "", tmbdId: movieId, posterUrl: nil, rating: 0)
        MovieManager.shared.loadMovieDetails(of: movieStub) { details in
            if let movieDetails = details {
                self.movieController.appendIfNotRepeated(movie: movieDetails.movie)
            } else {
                let message = "There was an error loading the movie just shared with you"
                ErrorMessageManager.shared.showError(message: message)
            }
        }
    }
}

extension PeerViewController: MovieListingControllerDelegate {
    func didSelect(movie: Movie) {
        selectedMovie = movie
        perform(segue: .toMovieDetailsViewControllerSegue)
    }
}
