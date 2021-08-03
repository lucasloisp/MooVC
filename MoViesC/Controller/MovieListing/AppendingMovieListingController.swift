//
//  AppendingMovieListingController.swift
//  MoViesC
//
//  Created by Lucas Lois on 3/8/21.
//

import Foundation

class AppendingMovieListingController: MovieListingController {
    func append(movie: Movie) {
        self.movies.append(movie)
        collectionView?.reloadData()
    }
}
