//
//  DiscoverViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 22/7/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    private var genres: [Genre]?
    // TODO: Build this for every movie
    private var moviePoster: UIImage?

    @IBOutlet weak var genresTableView: UITableView!
    @IBOutlet weak var pendingActivityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareTheTableView()
        loadGenres()
    }

    private func prepareTheTableView() {
        let genreNib = UINib(nibName: GenreTableViewCell.identifier, bundle: nil)
        let identifier = GenreTableViewCell.identifier
        genresTableView.register(genreNib, forCellReuseIdentifier: identifier)
        genresTableView.dataSource = self
    }

    private func loadGenres() {
        pendingActivityIndicatorView.isHidden = false
        genresTableView.isHidden = true
        APIClient.shared.requestItem(request: MovieDBRoute.getGenres) { (result: Result<GenresResponse, Error>) in
            switch result {
            case .success(let genresResponse):
                self.genres = genresResponse.genres
                self.loadMovieImage()
                self.genresTableView.reloadData()
            case .failure(let err):
                // TODO: Show the error to the user
                print(err)
            }
            self.genresTableView.isHidden = false
            self.pendingActivityIndicatorView.isHidden = true
        }
    }

    private func loadMovieImage() {
        let imageUrl =
            "https://developer.apple.com/home/images/hero-xcode-13/xcode-13-large.png"
        guard let url = URL(string: imageUrl) else {
            return
        }

        // Create data from url (You can handle exeption with try-catch)
        guard let data = try? Data(contentsOf: url) else {
            return
        }

        // Create image from data
        self.moviePoster = UIImage(data: data)
    }

}

extension DiscoverViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getGenreCell(tableView, for: indexPath)

        let genre = genres![indexPath.row]

        cell.configure(for: genre.name, showing: self.moviePoster)

        return cell
    }

    private func getGenreCell(_ tableView: UITableView, for indexPath: IndexPath) -> GenreTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GenreTableViewCell.identifier, for: indexPath)

        // swiftlint:disable:next force_cast
        return cell as! GenreTableViewCell
    }
}
