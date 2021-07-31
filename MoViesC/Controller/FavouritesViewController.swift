//
//  FavouritesViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 30/7/21.
//

import UIKit

class FavouritesViewController: UIViewController {

    private var movies: [Movie]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.title = "Favourites"

        loadAccountFavourites()
    }

    private func loadAccountFavourites() {
        MovieManager.shared.loadFavourites { movies in
            self.movies = movies
        }
    }
}
