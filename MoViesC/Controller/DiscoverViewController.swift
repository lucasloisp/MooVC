//
//  DiscoverViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 22/7/21.
//

import UIKit

class DiscoverViewController: UIViewController, WithSegues, WithLoadingIndicator {
    @IBOutlet weak var genresTableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    typealias SegueType = SeguesFromSelf
    enum SeguesFromSelf: String, PerformableSegue {
        case toMovieDetailsViewControllerSegue
        case toGenreDetailsViewControllerSegue
    }

    var viewsThatHideOnLoading: [UIView] { [genresTableView] }
    private var genreMoviesControllers: [GenreMovieListingController]?
    private var selectedMovie: Movie?
    private var selectedGenre: Genre?

    fileprivate var storedOffsets = [Int: CGFloat]()

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareTheTableView()
        loadGenres()
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.title = "Discover"
    }

    @IBSegueAction func makeDiscoverViewController(_ coder: NSCoder) -> MovieDetailsViewController? {
        guard let movie = selectedMovie else { return nil }
        return MovieDetailsViewController(coder: coder, for: movie)
    }

    @IBSegueAction func makeGenreDetailsViewController(_ coder: NSCoder) -> GenreDetailsViewController? {
        guard let genre = selectedGenre else { return nil }
        return GenreDetailsViewController(coder: coder, for: genre)
    }

    private func prepareTheTableView() {
        let genreNib = UINib(nibName: GenreTableViewCell.identifier, bundle: nil)
        let identifier = GenreTableViewCell.identifier
        genresTableView.register(genreNib, forCellReuseIdentifier: identifier)
        genresTableView.dataSource = self
        genresTableView.delegate = self
    }

    private func loadGenres() {
        startLoadingIndicator()
        MovieManager.shared.loadGenres { genreMovies in
            self.genreMoviesControllers = genreMovies.map({ (genre, movies) in
                let controller = GenreMovieListingController(for: genre)
                controller.updateData(movies: movies)
                controller.delegate = self
                controller.genreDelegate = self
                return controller
            })
            self.genresTableView.reloadData()
            self.stopLoadingIndicator()
        } onError: {
            // TODO: Indicate that there was an error to the user
            self.stopLoadingIndicator()
        }
    }
}

extension DiscoverViewController: GenreMovieListingControllerDelegate, MovieListingControllerDelegate {
    func loadMore(of genre: Genre) {
        self.selectedGenre = genre
        perform(segue: .toGenreDetailsViewControllerSegue)
    }

    func didSelect(movie: Movie) {
        self.selectedMovie = movie
        perform(segue: .toMovieDetailsViewControllerSegue)
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
