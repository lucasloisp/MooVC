//
//  DiscoverViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 22/7/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    private var genreMoviesControllers: [GenreMoviesCollectionViewController]?
    private var selectedMovie: Movie?

    fileprivate var storedOffsets = [Int: CGFloat]()

    @IBOutlet weak var genresTableView: UITableView!
    @IBOutlet weak var pendingActivityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareTheTableView()
        loadGenres()
    }

    @IBSegueAction func makeDiscoverViewController(_ coder: NSCoder) -> MovieDetailsViewController? {
        guard let movie = selectedMovie else { return nil }
        return MovieDetailsViewController(coder: coder, for: movie)
    }

    private func prepareTheTableView() {
        let genreNib = UINib(nibName: GenreTableViewCell.identifier, bundle: nil)
        let identifier = GenreTableViewCell.identifier
        genresTableView.register(genreNib, forCellReuseIdentifier: identifier)
        genresTableView.dataSource = self
        genresTableView.delegate = self
    }

    private func loadGenres() {
        pendingActivityIndicatorView.isHidden = false
        genresTableView.isHidden = true
        GenreMoviesManager.shared.loadGenres { genreMovies in
            self.genreMoviesControllers = genreMovies.map({ (genre, movies) in
                let controller = GenreMoviesCollectionViewController(for: genre, with: movies)
                controller.delegate = self
                return controller
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

extension DiscoverViewController: GenreMoviesCollectionViewControllerDelegate {
    func didSelect(movie: Movie) {
        self.selectedMovie = movie
        performSegue(withIdentifier: "toMovieDetailsViewControllerSegue", sender: nil)
    }
}

extension DiscoverViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreMoviesControllers?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getGenreCell(tableView, for: indexPath)

        let genreMoviesController = genreMoviesControllers![indexPath.row]

        genreMoviesController.bind(to: cell)

        cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0

        return cell
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? GenreTableViewCell else { return }

        storedOffsets[indexPath.row] = cell.collectionViewOffset
        cell.stopScrolling()
    }

    private func getGenreCell(_ tableView: UITableView, for indexPath: IndexPath) -> GenreTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GenreTableViewCell.identifier, for: indexPath)

        // swiftlint:disable:next force_cast
        return cell as! GenreTableViewCell
    }
}
