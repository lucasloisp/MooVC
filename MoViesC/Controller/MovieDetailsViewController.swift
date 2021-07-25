//
//  MovieDetailsViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 24/7/21.
//

import UIKit
import Kingfisher

class MovieDetailsViewController: UIViewController {
    let movie: Movie
    let formatter: DateFormatter
    var movieDetails: MovieDetails? {
        didSet {
            self.updateMovieDetails()
        }
    }
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!

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

        // Do any additional setup after loading the view.
        loadPosterImage()
        loadMovieDetails()
    }

    func loadPosterImage() {
        guard let posterUrl = movie.posterUrl else {
            posterImageView.image = UIImage(systemName: "xmark.rectangle")
            return
        }
        let placeholder = UIImage(systemName: "photo")
        posterImageView.contentMode = .scaleAspectFit
        let url = URL(string: "https://image.tmdb.org/t/p/w500" + posterUrl)
        posterImageView.kf.setImage(with: url, placeholder: placeholder, options: nil) { result in
            switch result {
            case .success(_):
                self.posterImageView.contentMode = .scaleAspectFill
            default:
                return
            }
        }
    }

    func loadMovieDetails() {
        let request = MovieDBRoute.getMovieDetails(movie: movie)
        APIClient.shared.requestItem(request: request) { (result: Result<MovieDetails, Error>) in
            switch result {
            case .success(let movieDetails):
                self.movieDetails = movieDetails
            case .failure(let err):
                // TODO: Implement
                print(err)
            }
        }
    }

    func updateMovieDetails() {
        guard let movieDetails = movieDetails else {
            taglineLabel.isHidden = true
            statusLabel.isHidden = true
            releaseDateLabel.isHidden = true
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
