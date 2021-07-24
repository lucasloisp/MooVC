//
//  DiscoverViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 22/7/21.
//

import UIKit

class GenreMoviesManager {
    static let shared = GenreMoviesManager()
    private init() {}

    func loadGenres(onSuccess: @escaping (([(Genre, [Movie])]) -> Void), onError: (() -> Void)) {
        APIClient.shared.requestItem(request: MovieDBRoute.getGenres) { (result: Result<GenresResponse, Error>) in
            switch result {
            case .success(let genresResponse):
                let genres = genresResponse.genres
                var movies: [[Movie]] = Array(repeating: [], count: genres.count)
                let group = DispatchGroup()
                genres.enumerated().forEach { (index, genre) in
                    group.enter()
                    let request = MovieDBRoute.discoverMoviesByGenre(genre: genre)
                    APIClient.shared.requestItem(request: request) { (result: Result<DiscoverMovieResponse, Error>) in
                        switch result {
                        case .success(let response):
                            movies[index] = response.movies
                        case .failure(let err):
                            // TODO: Show the error to the user
                            print(err)
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                  onSuccess(Array(zip(genres, movies)))
                }
            case .failure(let err):
                onError()
            }
        }

    }
}

class DiscoverViewController: UIViewController {
    private var genreMoviesControllers: [GenreMoviesCollectionViewController]?

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
        GenreMoviesManager.shared.loadGenres { genreMovies in
            self.genreMoviesControllers = genreMovies.map({ (genre, movies) in
                GenreMoviesCollectionViewController(for: genre, with: movies)
            })
            self.genresTableView.reloadData()
            self.genresTableView.isHidden = false
            self.pendingActivityIndicatorView.isHidden = true
        } onError: {
            // TODO: Indicate that there was an error to the user
            self.genresTableView.isHidden = false
            self.pendingActivityIndicatorView.isHidden = true
        }
    }

}

extension DiscoverViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreMoviesControllers?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getGenreCell(tableView, for: indexPath)

        let genreMoviesController = genreMoviesControllers![indexPath.row]

        genreMoviesController.bind(to: cell)

        return cell
    }

    private func getGenreCell(_ tableView: UITableView, for indexPath: IndexPath) -> GenreTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GenreTableViewCell.identifier, for: indexPath)

        // swiftlint:disable:next force_cast
        return cell as! GenreTableViewCell
    }
}
